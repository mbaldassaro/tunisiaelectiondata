//Map { background-color: #b8dee6; }

#cancelled {
  marker-width:[pct_cancelled] 	* 3;
  marker-fill:darken(#07f,20);
  marker-fill-opacity:.5;
  marker-line-width:0;
  marker-line-color:darken(#07f,20);
  marker-allow-overlap:true;
  marker-comp-op:screen;
  [zoom=9] { marker-line-width: .75; }
  [zoom=10]{ marker-line-width:1.00; }
  [zoom=11]{ marker-line-width:1.25; }
  [zoom=12]{ marker-line-width:1.50; }
  [zoom=13]{ marker-line-width:1.75; }
  [zoom=13]{ marker-line-width:2.00; }
}
  