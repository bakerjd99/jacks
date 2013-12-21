using System;
using System.Data;
using System.Collections.Generic;
using System.Text;
using JEXEServerLib;
using System.ComponentModel;

namespace JServerClass
{
    /// <summary>
    /// Created by:   John D. Baker 
    /// Last Change:  2010nov27
	/// See: http://bakerjd99.wordpress.com/2010/05/28/a-c-net-class-for-calling-j/
    /// 
    /// Changes: 
    /// 2010nov27     new get overload that returns general object
    ///
    /// EMail:        bakerjd99@gmail.com
    /// </summary>
    /// <remarks>A J/.Net interface class.</remarks>
    public class JServer : IDisposable
    {
        #region consts instance variables

        // j com exe server object
        private JEXEServer jObject;
       
        // state variables
        private bool jDisposed = false;
        private bool jShowToggle = false;

        // return codes 
        private const int BADRC = -777;
        private const int TRAPRC = -999;
        private const int OKRC = 0;

        // j exe server object always loads the j profile
        private const string BINPATH = "BINPATH_z_=:1!:46''";
        private const string ARGV = "ARGV_z_=:,<'CSsrv'";
        private const string JPROFILE = "0!:0 <BINPATH,'\\profile.ijs'";
        private const string SQUOTE = "'";

        // j locale suffix and nouns
        private const string LOCALE = "_CSsrv_";
        private const string RCS = "RC" + LOCALE;
        private const string TMPS = "TMP" + LOCALE;
        private const string TMPS2 = "TMP2" + LOCALE;
        private const string ERRS = "ERR" + LOCALE;
        private const string CLEARTMPS = "(4!:55) ;:" + SQUOTE + RCS + 
            " " + TMPS + " " + TMPS2 + SQUOTE;

        // script load expressions trap J errors 
        private const string SCRIPTLOAD = RCS + "=:(0:`])@.(_9&-:)((0!:0) :: _9:)<'";
        private const string LIBLOAD = RCS + "=:(0:`])@.(_9&-:)(load :: _9:)'";
        private const string NOUNLOAD = RCS + "=:(0:`])@.(_9&-:)((0!:100) :: _9:) ";
        private const string LOADERROR = "Library/Script load failure -> ";

        // datatable related constants
        private const string ISDATATABLE = "isDataTable" + LOCALE + " ";
        private const string DTCOLUMNINFO = "dtColumnInfo" + LOCALE + " ";
        private const string DTTABLEDATA = "dtTableData" + LOCALE + " ";
        private const string DTDATATABLEFRTRDATA = " dtDataTableFrTrdata" + LOCALE + " ";
        private const string DTFINALDATATABLE = "(" + TMPS2 + ";" + TMPS + ")" + DTDATATABLEFRTRDATA;

        // supported j datatable representation column types 
        private string JDTCOLUMNS = "System.String|System.Int32|System.Double|System.Boolean|System.DateTime";

        // datetime representation related
        private const string DATETIMEFMT = "yyyy MM dd HH mm ss";
        private const string TSENCODE = "tsrep" + LOCALE + " ";
        private const string TSDECODE = "<.1 tsrep" + LOCALE + " ";

        private const int ISDT = 31;
        private const int COLTITLES = 1;
        private const int CSTYPES = 3;
        private const int DTCELLALLOC = 25;

        #endregion consts instance variables

        #region constructor related

        // clarifies argument codes for callers
        public enum JScriptType
        {
            Script,
            Library,
            OnlyProfile,
            Noun
        }

        // constructorb - only one no overloads
        public JServer(JScriptType jLoadType, params string[] jScripts)
        {
            try
            {
                this.jSetup(jLoadType, jScripts);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        // destructor & Dispose 
        ~JServer()
        {
                Dispose(false); 
        }

        public void Dispose()
        {
            try
            {
                Dispose(true);
                GC.SuppressFinalize(this);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        
        private void Dispose(bool jDisposing)
        {
            if (!this.jDisposed)
            {
                if (jDisposing)
                {
                    // Dispose managed resources.
                    //Component.Dispose();
                    try
                    {
                        jObject.Quit();
                        jObject = null;
                    }
                    catch
                    {
                        jObject = null;
                    }
                }


                // Force garbage collection
                GC.Collect();
            }
            this.jDisposed = true;
        }

        #endregion constructor related

        #region utils

        public bool jShowServer
        {
            get
            {
                return jShowToggle;
            }
            set
            {
                jShowToggle = value;
                jShow(jShowToggle);
            }
        }

        public void jDo(string jString)
        {
            try
            {
                int rc = BADRC;

                rc = jObject.Do(jString);
                if (rc > 0)
                {
                    string jerr = jErrorText(rc);
                    Exception eoe = new Exception(jerr);
                    throw eoe;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void jShow(bool OnOff)
        {
            int rc = BADRC;
            int jin;

            jin = OnOff ? 1 : 0;
            rc = jObject.Show(jin);
        }

        public string jVersion()
        {
            try
            {
                string jstr = "";

                // j locale CSsrv is only used by these
                // C# functions when communicating with J 
                jDo("JVERSION" + LOCALE + "=: (9!:14''),' st:',Afmt" + LOCALE + " 9!:12 ''");
                jGet("JVERSION" + LOCALE, out jstr);

                return jstr;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private string jErrorText(int jRc)
        {
            try
            {
                string jstr;
                object jout;
                jObject.ErrorTextB(jRc, out jout);
                jstr = Convert.ToString(jout);
                return jstr;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        #endregion utils

        #region jSetup 

        private void jNew()
        {
            try
            {
                int rc = BADRC;

                jObject = new JEXEServerLib.JEXEServer();

                // set J to quit and log input lines
                rc = jObject.Quit();
                rc = jObject.Log(1);

                // hide J window 
                // Note: we get a window flash  
                // before this command takes effect
                rc = jObject.Show(0);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        private void jProfile()
        {
            try
            {
                // start J server
                jNew();

                // set some internal J nouns
                jDo(BINPATH);
                jDo(ARGV);

                // load profile
                jDo(JPROFILE);

                // CSsrv j script is used by the functions in this  
                // class to facilitate communication with the J server
                string CSsrv = UnicodeEncoding.ASCII.GetString(JserverResources.CSsrv);
                string boot = "BootScript" + LOCALE;
                jSet(boot, CSsrv);
                jDo(NOUNLOAD + boot);
                jDo("(4!:55) <" + SQUOTE + boot + SQUOTE);

                // Check return code of boot load 
                int jrc = BADRC;
                jGet(RCS, out jrc);
                if (jrc != OKRC)
                {
                    string jerr = jLoadError();
                    Exception eoe = new Exception(jerr);
                    throw eoe;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void jSetup(JScriptType jsType, params string[] jScripts)
        {
            try
            {
                // default setup
                jProfile();

                if (jsType == JScriptType.OnlyProfile) return;

                string loadpfx = "";

                if (JScriptType.Noun == jsType)
                {
                    // load nouns (strings of j code)
                    loadpfx = NOUNLOAD + TMPS;
                    foreach (string str in jScripts)
                    {
                        jSet(TMPS, str);
                        jLoad(loadpfx);
                        jDo(CLEARTMPS);
                    }
                    return;
                }

                if (JScriptType.Library == jsType) loadpfx = LIBLOAD;
                else if (JScriptType.Script == jsType) loadpfx = SCRIPTLOAD;
                else
                {
                    string jerr = "invalid j load script";
                    Exception eoe = new Exception(jerr);
                    throw eoe;
                }

                // load libraries or script files
                foreach (string scr in jScripts)
                {
                    jLoad(loadpfx + scr + SQUOTE);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void jLoad(string loadcom)
        {
            try
            {
                int jrc = OKRC;
                string jerr = "";

                jDo(loadcom);
                jGet(RCS, out jrc);
                if (jrc != OKRC)
                {
                    jerr = jLoadError();
                    Exception eoe = new Exception(jerr);
                    throw eoe;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private string jLoadError()
        {
            try
            {
                // library and script loads run under J traps
                // collect the last J error and throw it
                string jerr = "";
                jDo(ERRS + "=: 13!:12 ''");
                jGet(ERRS, out jerr);
                jerr = LOADERROR + jerr;
                return jerr;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public void jLoad(JScriptType jsType, string jScript)
        {
            try
            {
                if (jsType == JScriptType.OnlyProfile) return;
                string loadpfx = (jsType == JScriptType.Library) ? LIBLOAD : SCRIPTLOAD;
                jLoad(loadpfx + jScript + SQUOTE);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        #endregion jSetup

        #region jSet Overloads

        public void jSet(string jName, bool jInput)
        {
            try
            {
                int rc = BADRC;
                object jin;

                jin = (object)jInput;
                rc = jObject.Set(jName, ref jin);
                if (rc > 0)
                {
                    string jerr = jErrorText(rc);
                    Exception eoe = new Exception(jerr);
                    throw eoe;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void jSet(string jName, bool[] jInput)
        {
            try
            {
                int rc = BADRC;
                object jin;

                jin = (object)jInput;
                rc = jObject.Set(jName, ref jin);
                if (rc > 0)
                {
                    string jerr = jErrorText(rc);
                    Exception eoe = new Exception(jerr);
                    throw eoe;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void jSet(string jName, bool[,] jInput)
        {
            try
            {
                int rc = BADRC;
                object jin;

                jin = (object)jInput;
                rc = jObject.Set(jName, ref jin);
                if (rc > 0)
                {
                    string jerr = jErrorText(rc);
                    Exception eoe = new Exception(jerr);
                    throw eoe;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void jSet(string jName, byte jInput)
        {
            try
            {
                int rc = BADRC;
                object jin;

                jin = (object)jInput;
                rc = jObject.Set(jName, ref jin);
                if (rc > 0)
                {
                    string jerr = jErrorText(rc);
                    Exception eoe = new Exception(jerr);
                    throw eoe;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void jSet(string jName, byte[] jInput)
        {
            try
            {
                int rc = BADRC;
                object jin;

                jin = (object)jInput;
                rc = jObject.Set(jName, ref jin);
                if (rc > 0)
                {
                    string jerr = jErrorText(rc);
                    Exception eoe = new Exception(jerr);
                    throw eoe;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void jSet(string jName, byte[,] jInput)
        {
            try
            {
                int rc = BADRC;
                object jin;

                jin = (object)jInput;
                rc = jObject.Set(jName, ref jin);
                if (rc > 0)
                {
                    string jerr = jErrorText(rc);
                    Exception eoe = new Exception(jerr);
                    throw eoe;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void jSet(string jName, DateTime jInput)
        {
            try
            {
                int[] jNumdate = new int[6];
                jNumdate[0] = jInput.Year;
                jNumdate[1] = jInput.Month;
                jNumdate[2] = jInput.Day;
                jNumdate[3] = jInput.Hour;
                jNumdate[4] = jInput.Minute;
                jNumdate[5] = jInput.Second;

                // send to j - convert to (tsrep) format
                jSet(jName, jNumdate);
                jDo(jName + "=:" + TSENCODE + jName);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void jSet(string jName, DateTime[] jInput)
        {
            try
            {
                int rows = jInput.Length;
                int[,] jNumdate = new int[rows,6];
                for (int i = 0; i < rows; i++)
                {
                    jNumdate[i,0] = jInput[i].Year;
                    jNumdate[i,1] = jInput[i].Month;
                    jNumdate[i,2] = jInput[i].Day;
                    jNumdate[i,3] = jInput[i].Hour;
                    jNumdate[i,4] = jInput[i].Minute;
                    jNumdate[i,5] = jInput[i].Second;
                }

                // send to j - convert to (tsrep) format
                jSet(jName, jNumdate);
                jDo(jName + "=:" + TSENCODE + jName);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void jSet(string jName, double jInput)
        {
            try
            {
                int rc = BADRC;
                object jin;

                jin = (object)jInput;
                rc = jObject.Set(jName, ref jin);
                if (rc > 0)
                {
                    string jerr = jErrorText(rc);
                    Exception eoe = new Exception(jerr);
                    throw eoe;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void jSet(string jName, double[] jInput)
        {
            try
            {
                int rc = BADRC;
                object jin;

                jin = (object)jInput;
                rc = jObject.Set(jName, ref jin);
                if (rc > 0)
                {
                    string jerr = jErrorText(rc);
                    Exception eoe = new Exception(jerr);
                    throw eoe;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void jSet(string jName, double[,] jInput)
        {
            try
            {
                int rc = BADRC;
                object jin;

                jin = (object)jInput;
                rc = jObject.Set(jName, ref jin);
                if (rc > 0)
                {
                    string jerr = jErrorText(rc);
                    Exception eoe = new Exception(jerr);
                    throw eoe;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void jSet(string jName, int jInput)
        {
            try
            {
                int rc = BADRC;
                object jin;

                jin = (object)jInput;
                rc = jObject.Set(jName, ref jin);
                if (rc > 0)
                {
                    string jerr = jErrorText(rc);
                    Exception eoe = new Exception(jerr);
                    throw eoe;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void jSet(string jName, int[] jInput)
        {
            try
            {
                int rc = BADRC;
                object jin;

                jin = (object)jInput;
                rc = jObject.Set(jName, ref jin);
                if (rc > 0)
                {
                    string jerr = jErrorText(rc);
                    Exception eoe = new Exception(jerr);
                    throw eoe;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void jSet(string jName, int[,] jInput)
        {
            try
            {
                int rc = BADRC;
                object jin;

                jin = (object)jInput;
                rc = jObject.Set(jName, ref jin);
                if (rc > 0)
                {
                    string jerr = jErrorText(rc);
                    Exception eoe = new Exception(jerr);
                    throw eoe;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void jSet(string jName, string jInput)
        {
            try
            {
                int rc = BADRC;
                object jin;

                jin = (object)jInput;
                rc = jObject.SetB(jName, ref jin);
                if (rc > 0)
                {
                    string jerr = jErrorText(rc);
                    Exception eoe = new Exception(jerr);
                    throw eoe;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void jSet(string jName, string[] jInput)
        {
            try
            {
                // This is a very useful case and it would be nice if the 
                // current J COM interface directly supported string arrays.
                // This implementation is Ok for short (<200) blcl arrays.

                int len = jInput.Length;

                // set blcl in J server
                jDo(jName + "=:(" + len.ToString() + ")$<''");

                // insert substrings 
                for (int i = 0; i < len; i++)
                {
                    jSet(TMPS, jInput[i]);
                    jDo(jName + "=:(<" + TMPS + ") (" + i.ToString() + ")} " + jName);
                }

                // clear temp
                jDo("(4!:55) <'" + TMPS + SQUOTE);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        #endregion jSet Overloads

        #region jGet Overloads

        public void jGet(string jName, out bool jOutput)
        {
            try
            {
                int rc = BADRC;
                object jout;

                rc = jObject.Get(jName, out jout);
                if (rc > 0)
                {
                    string jerr = jErrorText(rc);
                    Exception eoe = new Exception(jerr);
                    throw eoe;
                }

                jOutput = (bool)jout;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void jGet(string jName, out bool[] jOutput)
        {
            try
            {
                int rc = BADRC;
                object jout;

                rc = jObject.Get(jName, out jout);
                if (rc > 0)
                {
                    string jerr = jErrorText(rc);
                    Exception eoe = new Exception(jerr);
                    throw eoe;
                }
                jOutput = (bool[])jout;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void jGet(string jName, out bool[,] jOutput)
        {
            try
            {
                int rc = BADRC;
                object jout;

                rc = jObject.Get(jName, out jout);
                if (rc > 0)
                {
                    string jerr = jErrorText(rc);
                    Exception eoe = new Exception(jerr);
                    throw eoe;
                }
                jOutput = (bool[,])jout;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void jGet(string jName, out byte jOutput)
        {
            try
            {
                int rc = BADRC;
                object jout;

                rc = jObject.Get(jName, out jout);
                if (rc > 0)
                {
                    string jerr = jErrorText(rc);
                    Exception eoe = new Exception(jerr);
                    throw eoe;
                }

                jOutput = (byte)jout;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void jGet(string jName, out byte[] jOutput)
        {
            try
            {
                int rc = BADRC;
                object jout;

                rc = jObject.Get(jName, out jout);
                if (rc > 0)
                {
                    string jerr = jErrorText(rc);
                    Exception eoe = new Exception(jerr);
                    throw eoe;
                }
                jOutput = (byte[])jout;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void jGet(string jName, out byte[,] jOutput)
        {
            try
            {
                int rc = BADRC;
                object jout;

                rc = jObject.Get(jName, out jout);
                if (rc > 0)
                {
                    string jerr = jErrorText(rc);
                    Exception eoe = new Exception(jerr);
                    throw eoe;
                }
                jOutput = (byte[,])jout;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void jGet(string jName, out DateTime jOutput)
        {
            try
            {
                // decode and fetch J (tsrep) datetime representation
                int[] jNumdate;
                jDo(TMPS + "=:" + TSDECODE + jName);
                jGet(TMPS, out jNumdate);
                if (6 != jNumdate.Length)
                {
                    string jerr = "invalid (tsrep) DateTime length";
                    Exception eoe = new Exception(jerr);
                    throw eoe;
                }

                DateTime jDtime = new DateTime(jNumdate[0], jNumdate[1], jNumdate[2], jNumdate[3], jNumdate[4], jNumdate[5]);
                jOutput = jDtime;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void jGet(string jName, out DateTime[] jOutput)
        {
            try
            {
                // decode and fetch J (tsrep) datetime representations
                int[,] jNumdate;
                jDo(TMPS + "=:" + TSDECODE + jName);
                jGet(TMPS, out jNumdate);
                jDo("(4!:55)<'" + TMPS + SQUOTE);

                int rows = 1 + jNumdate.GetUpperBound(0);
                int cols = 1 + jNumdate.GetUpperBound(1);

                if (6 != cols)
                {
                    string jerr = "invalid (tsrep) DateTime length";
                    Exception eoe = new Exception(jerr);
                    throw eoe;
                }

                DateTime[] jDtlist = new DateTime[rows];
                for (int i = 0; i < rows; i++)
                {
                    DateTime jDtime = new DateTime(jNumdate[i,0], jNumdate[i,1], jNumdate[i,2], jNumdate[i,3], jNumdate[i,4], jNumdate[i,5]);
                    jDtlist[i] = jDtime;
                }
                jOutput = jDtlist;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void jGet(string jName, out double jOutput)
        {
            try
            {
                int rc = BADRC;
                object jout;

                rc = jObject.Get(jName, out jout);
                if (rc > 0)
                {
                    string jerr = jErrorText(rc);
                    Exception eoe = new Exception(jerr);
                    throw eoe;
                }
                jOutput = (double)jout;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void jGet(string jName, out double[] jOutput)
        {
            try
            {
                int rc = BADRC;
                object jout;

                rc = jObject.Get(jName, out jout);
                if (rc > 0)
                {
                    string jerr = jErrorText(rc);
                    Exception eoe = new Exception(jerr);
                    throw eoe;
                }
                jOutput = (double[])jout;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void jGet(string jName, out double[,] jOutput)
        {
            try
            {
                int rc = BADRC;
                object jout;

                rc = jObject.Get(jName, out jout);
                if (rc > 0)
                {
                    string jerr = jErrorText(rc);
                    Exception eoe = new Exception(jerr);
                    throw eoe;
                }
                jOutput = (double[,])jout;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void jGet(string jName, out int jOutput)
        {
            try
            {
                int rc = BADRC;
                object jout;

                rc = jObject.Get(jName, out jout);
                if (rc > 0)
                {
                    string jerr = jErrorText(rc);
                    Exception eoe = new Exception(jerr);
                    throw eoe;
                }
                jOutput = (int)jout;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        
        // general object (no casting) added to interface
        // to handle cases when the basic types are not sufficient
        public void jGet(string jName, out object jOutput)
        {
            try
            {
                int rc = BADRC;
                object jout;

                rc = jObject.Get(jName, out jout);
                if (rc > 0)
                {
                    string jerr = jErrorText(rc);
                    Exception eoe = new Exception(jerr);
                    throw eoe;
                }
                jOutput = jout;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void jGet(string jName, out int[] jOutput)
        {
            try
            {
                int rc = BADRC;
                object jout;

                rc = jObject.Get(jName, out jout);
                if (rc > 0)
                {
                    string jerr = jErrorText(rc);
                    Exception eoe = new Exception(jerr);
                    throw eoe;
                }
                jOutput = (int[])jout;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void jGet(string jName, out int[,] jOutput)
        {
            try
            {
                int rc = BADRC;
                object jout;

                rc = jObject.Get(jName, out jout);
                if (rc > 0)
                {
                    string jerr = jErrorText(rc);
                    Exception eoe = new Exception(jerr);
                    throw eoe;
                }
                jOutput = (int[,])jout;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void jGet(string jName, out string jOutput)
        {
            try
            {
                int rc = BADRC;
                object jout;

                rc = jObject.GetB(jName, out jout);
                if (rc > 0)
                {
                    string jerr = jErrorText(rc);
                    Exception eoe = new Exception(jerr);
                    throw eoe;
                }
                jOutput = (string)jout;
            }
            catch (Exception ex)
            {
                throw ex;
            }  
        }

        public void jGet(string jName, out string[] jOutput)
        {
            try
            {
                int rc = BADRC;
                object jout;
                object[] jtmp;

                rc = jObject.GetB(jName, out jout);
                if (rc > 0)
                {
                    string jerr = jErrorText(rc);
                    Exception eoe = new Exception(jerr);
                    throw eoe;
                }
                jtmp = (object[])jout;

                int len = jtmp.Length;
                string[] jstr = new string[len];

                for (int i = 0; i < len; i++)
                    jstr[i] = (string)jtmp[i];

                jOutput = jstr;
            }
            catch (Exception ex)
            {
                throw ex;
            }         
        }

        public void jGet(string jName, out string[,] jOutput)
        {
            try
            {
                int rc = BADRC;
                object jout;
                object[,] jtmp;
                int rows, cols;

                rc = jObject.GetB(jName, out jout);
                if (rc > 0)
                {
                    string jerr = jErrorText(rc);
                    Exception eoe = new Exception(jerr);
                    throw eoe;
                }
                jtmp = (object[,])jout;

                rows = 1 + jtmp.GetUpperBound(0);
                cols = 1 + jtmp.GetUpperBound(1);
                string[,] jstr = new string[rows, cols];

                for (int i = 0; i < rows; i++)
                    for (int j = 0; j < cols; j++)
                        jstr[i, j] = (string)jtmp[i, j];

                jOutput = jstr;
            }
            catch (Exception ex)
            {
                throw ex;
            }  
        }


        #endregion jGet Overloads

        #region DataTable Overloads


        public DataTable jGet(string jName)
        {
            try
            {
                int rc = BADRC;

                // is requested object a J datatable representation?
                jDo(RCS + "=:" + ISDATATABLE + SQUOTE + jName + SQUOTE);
                jGet(RCS, out rc);
                if (rc != ISDT)
                {
                    string jerr = "no j server datatable with name (" + jName + ")";
                    Exception eoe = new Exception(jerr);
                    throw eoe;
                }

                DataTable dt = new DataTable();

                // get column information 
                jDo(TMPS + "=:" + DTCOLUMNINFO + jName);
                string[,] colinfo;
                jGet(TMPS, out colinfo);

                int colsinfo = 1 + colinfo.GetUpperBound(1);

                // set columns in datatable 
                // columns may be string, bool, int, double or DateTime
                // column type declarations matter when entering data into 
                // the grid but items are still loaded as strings
                string[] rowdata = new string[colsinfo];
                bool nodates = true;
                bool[] nodatebit = new bool[colsinfo];
                for (int i = 0; i < colsinfo; i++)
                {
                    string coltype = colinfo[CSTYPES, i];
                    nodatebit[i] = true;
                    switch(coltype)
                    {
                        case "string":
                           dt.Columns.Add(new DataColumn(colinfo[COLTITLES,i], typeof(string)));
                           break;
                        case "int":
                           dt.Columns.Add(new DataColumn(colinfo[COLTITLES,i], typeof(int)));          
                           break;
                        case "double":
                           dt.Columns.Add(new DataColumn(colinfo[COLTITLES, i], typeof(double)));
                           break;
                        case "bool":
                           dt.Columns.Add(new DataColumn(colinfo[COLTITLES, i], typeof(bool)));
                           break;
                        case "datetime":
                           dt.Columns.Add(new DataColumn(colinfo[COLTITLES, i], typeof(DateTime)));
                           nodates = false;
                           nodatebit[i] = nodates;
                           break;
                        default:
                           string jerr = "invalid j DataTable column type";
                           Exception eoe = new Exception(jerr);
                           throw eoe;
                    }
                    rowdata[i] = colinfo[COLTITLES, i];
                }

                // fetch and load data
                jDo(TMPS + "=:" + DTTABLEDATA + jName);

                // NIMP may be faster to fetch as a single string and parse in C#
                // - the string[,] get case is one of the slowest 
                string[,] dtdata;
                jGet(TMPS, out dtdata);
                jDo(CLEARTMPS);

                int rows = 1 + dtdata.GetUpperBound(0);
                int cols = 1 + dtdata.GetUpperBound(1);
                if (cols != colsinfo)
                {
                    string jerr = "column header data mismatch";
                    Exception eoe = new Exception(jerr);
                    throw eoe;
                }

                // datetime columns require special treatment
                // if no such columns are present do not penalize
                // the following loops with repeated irrelevant tests
                if (nodates)
                {
                    for (int i = 0; i < rows; i++)
                    {
                        for (int j = 0; j < cols; j++)
                            rowdata[j] = dtdata[i, j];
                        dt.Rows.Add(rowdata);
                    }
                }
                else
                {
                    for (int i = 0; i < rows; i++)
                    {
                        for (int j = 0; j < cols; j++)
                        {
                            if (nodatebit[j])
                                rowdata[j] = dtdata[i, j];
                            else
                            {
                                // j datetime strings are in YYYY/MM/DD HR:MN:SS format
                                rowdata[j] = DateTime.Parse(dtdata[i,j]).ToString(); 
                            }
                        }
                        dt.Rows.Add(rowdata);
                    }
                }

                return dt;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void jSet(string jName, DataTable dt)
        {
            try
            {
                int rows = dt.Rows.Count;
                int cols = dt.Columns.Count;

                // insure nonzero allocations
                int allocrows = 1 + rows;
                int alloccols = 1 + cols;
                  
                // WARNING delimiter choice is limited by the j COM interface
                string dLe = "\r";
                string dIt = "\t";

                StringBuilder jdtCols = new StringBuilder("", DTCELLALLOC * alloccols);
                DataColumn dc = new DataColumn();
                bool[] isdatetime = new bool[cols];
                for (int i = 0; i < cols; i++)
                {
                    jdtCols.Append(dLe);
                    dc = dt.Columns[i];
                    string dtname = dc.DataType.FullName;

                    // insure only supported columns
                    if (-1 == JDTCOLUMNS.IndexOf(dtname))
                    {
                        string jerr = "unsupported j datatable column type (" + dtname + ")";
                        Exception eoe = new Exception(jerr);
                        throw eoe;
                    }
                    
                    isdatetime[i] = "System.DateTime" == dtname;
                    jdtCols.Append(dIt + dt.Columns[i].Caption + dIt + dtname);
                }
                jSet(TMPS, jdtCols.ToString());

                // to check delimiter balance in j we need row count
                jSet(TMPS2, rows);

                // NIMP TEST CASE - my understanding is that if the capacity of
                // of the stringbuilder object is exceeded more memory is automatically 
                // allocated produce a test case for this scenario
                StringBuilder jdtStr = new StringBuilder("", DTCELLALLOC * allocrows * alloccols);
                if (0 < rows)
                {
                    for (int i = 0; i < rows; i++)
                    {
                        jdtStr.Append(dLe);

                        object[] rowdata = (object[])dt.Rows[i].ItemArray;
                        for (int j = 0; j < cols; j++)
                        {
                            if (isdatetime[j])
                            {
                                DateTime dtob = (DateTime)rowdata[j];
                                jdtStr.Append(dIt + String.Format("{0:yyyy/M/d H:m:s}", dtob));
                            }
                            else
                                jdtStr.Append(dIt + rowdata[j].ToString());
                        }
                    }   
                }
                jSet(jName, jdtStr.ToString());

                // final j datatable representation
                jDo(SQUOTE + RCS + " " + jName + SQUOTE + "=:" + DTFINALDATATABLE + jName);
                int jrc = BADRC;
                jGet(RCS, out jrc);
                jDo(CLEARTMPS);
                if (ISDT != jrc)
                {
                    string jerr = "unbalanced j datatable delimiters";
                    Exception eoe = new Exception(jerr);
                    throw eoe;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        #endregion DataTable Overloads


    }
}

