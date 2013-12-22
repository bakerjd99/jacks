//  Example function that extracts data from the free DHTMLX grid see:
//
//  http://bakerjd99.wordpress.com/2012/12/04/more-about-jhs-with-dhtmlx-the-grid/

function ev_saveme_click(){

  if ('undefined' != typeof grid0){

    if (0 == grid0.getRowsNum()){
      jbyid("rerowcnt").innerHTML = "No rows to save";
      return;
    }

    var st = new Date().getTime(),  // start time
        ids = grid0.getAllRowIds(","),
        ccnt = 1 + grid0.getColumnsNum();  // includes id

    ids = ids.split(",");
    var rcnt = ids.length,
        tab = new Array(rcnt);

    // header row - tab[0][0] cell ignored
    tab[0] = new Array(ccnt);
    for (var i = 1; i < ccnt; i++) {
      tab[0][i] = grid0.getColumnLabel(i-1,0);
    }

    // cells with leading row id
    for (var i = 0 , si = 1 ; i < rcnt; i++ , si++) {
      tab[si] = new Array(ccnt);
      for (var j = 1; j < ccnt; j++) {
        tab[si][j] = grid0.cells((+ids[i]),j-1).getValue();
      }
      tab[si][0] = ids[i];
    }

    // prefix row column counts
    var pfx = (rcnt+1) + " " + ccnt + "*";
    jbyid("gridchgs").innerHTML = pfx + JSON.stringify(tab);
    jdoajax(["gridchgs","tout"],"");

    var et = new Date().getTime() - st;  // end time
    jbyid("rerowcnt").innerHTML= " row count= " + grid0.getRowsNum() +
        ",  JavaScript ms= " + et;

  } else {

    jbyid("rerowcnt").innerHTML= "Nothing to save";
  }
}