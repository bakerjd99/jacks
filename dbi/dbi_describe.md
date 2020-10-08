
Using `dbi.ijs`
===============

See [APL Software Archaeology `.dbi` Edition](https://analyzethedatanotthedrivel.org/2013/12/26/apl-software-archaeology-dbi-edition/)
for more information.

Using the J `dbi.ijs` script is simple. The included file 
[`allnsf.dbi`](https://github.com/bakerjd99/jacks/blob/master/dbi/allnsf.dbi) is
an example `.dbi` file that holds all the *field types* supported by
`dbi.ijs`. Simple fields are similar to SQL database columns and result 
in single column tables when fetched. Repeated fields are actually tables
and result in tables when fetched. All fields are stored as contiguous byte
runs in the `.dbi` file making access as fast as it's ever going to get.  

The `.dbi` format works very well for numeric (integer and floating point)
vectors and tables. The byte representation of `.dbi` matches
the native format of the host and can be easily read and written
by other programs. Simple ASCII character data is supported but
the `.dbi` format is not text oriented.

To run download the [GitHub `dbi` directory](https://github.com/bakerjd99/jacks/tree/master/dbi)
to a local directory. I placed the files in `c:/temp`.

Load `dbi.ijs`:

           load 'c:/temp/dbi.ijs'
		
View the file template:

           dbitemplate 'c:/temp/allnsf.dbi'
        ┌──────┬───┬─────┬───┬─────┬───┬─────┬────┬──────┬────┬──────┬────┬──────┬───┬──┬───┐
        │ALLNSF│u1f│u21u1│u4f│u17u4│u8f│u37u8│i16f│i16i16│i32f│i20i32│f64f│f97f64│d6f│c0│c15│
        ├──────┼───┼─────┼───┼─────┼───┼─────┼────┼──────┼────┼──────┼────┼──────┼───┼──┼───┤
        │1713  │U1 │21U1 │U4 │17U4 │U8 │37U8 │I16 │16I16 │I32 │20I32 │F64 │97F64 │D6 │C0│C15│
        └──────┴───┴─────┴───┴─────┴───┴─────┴────┴──────┴────┴──────┴────┴──────┴───┴──┴───┘	

This file has 1713 *records.* Read all the fields:

           d=. dbiread 'c:/temp/allnsf.dbi'

The result is a two row boxed table. The first row contains field names and
the second row holds the field data.

           list 0 { d
        ALLNSF_u1f    ALLNSF_u21u1  ALLNSF_u4f    ALLNSF_u17u4  ALLNSF_u8f    
        ALLNSF_u37u8  ALLNSF_i16f   ALLNSF_i16i16 ALLNSF_i32f   ALLNSF_i20i32 
        ALLNSF_f64f   ALLNSF_f97f64 ALLNSF_d6f    ALLNSF_c0     ALLNSF_c15

           list datatype&.> 1 { d  NB. fields have various J datatypes
        boolean  boolean  integer  integer  integer  integer  integer  integer  
        integer  integer  floating floating integer  literal  literal

Indirect assignment is a handy way to extract all the fields as nouns:

          (0{d)=: 1{d 
   
          names''
       ALLNSF_c0     ALLNSF_c15    ALLNSF_d6f    ALLNSF_f64f   ALLNSF_f97f64 
       ALLNSF_i16f   ALLNSF_i16i16 ALLNSF_i20i32 ALLNSF_i32f   ALLNSF_u17u4  
       ALLNSF_u1f    ALLNSF_u21u1  ALLNSF_u37u8  ALLNSF_u4f    ALLNSF_u8f  
       d	   

Creating and writing a new `.dbi` is straight forward. 

          t=. dbitemplate 'c:/temp/allnsf.dbi'
		  
Start the new file with 0 records. The system preallocates file space
if the record count is not zero.

		  tc =. (<":0) (<1;0)} t
		  
		  NB. nonzero result indicates success
          tc dbicreate 'c:/temp/allcopy.dbi'
       2048
		  
		  NB. write all fields - result is byte count
          d dbiwrite 'c:/temp/allcopy.dbi'
       1782243
	   
Read the copy back and compare data:

          dc =.dbiread 'c:/temp/allcopy.dbi'
		  (1{d) -: 1{dc
       1

The `.dbi` system can read and write single fields and supports datetime data. 
See code comments for more details.

John Baker
original: December 26, 2013
revised: October 8, 2020
