NB.*startup_mathjaxdemo_jhs s-- start MathJaxDemo when JHS loads.
NB.
NB. Copy this file to J's installed config directory
NB. (jpath '~config') and rename it (startup_jhs.ijs).
NB.
NB. JHS runs this script when it starts. After
NB. running browse to url:
NB.   
NB. http://127.0.0.1:65001/MathJaxDemo

smoutput 0 : 0
This is a JHS MathJax demo - ehh!
)

NB. hide console window (windows only)
NB. jshowconsole_j_ 0

NB. load demo script 
load '~MathJaxDemo/MathJaxDemo.ijs'
