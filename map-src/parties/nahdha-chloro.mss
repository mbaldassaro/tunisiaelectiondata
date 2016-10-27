// Use this stylesheet to show a chloropleth map of ennahdha's
// share of the electorate.
// You will probably want to comment out all other style sheets,
// though this is not necessary.

/*
#parties::chloropleth {
  polygon-opacity:.45;
  line-color:#def;
  line-opacity:.15;
  line-width:.5;
	[ratio_n<= 20] { polygon-fill: #07f;}
	[ratio_n > 20] { polygon-fill: darken(spin(#07f, -2),10);}
	[ratio_n > 30] { polygon-fill: darken(spin(#07f, -4),25);}
	[ratio_n > 40] { polygon-fill: darken(spin(#07f, -8),40);}
  comp-op:hard-light;
}

#parties::glow {
  polygon-opacity:0;
  opacity: 0.15;
  line-join: round;
  line-color:#fff;
  [zoom=2] { line-width: 3 / 5; }
  [zoom=3] { line-width: 5 / 5; }
  [zoom=4] { line-width: 8 / 5; }
  [zoom=5] { line-width: 12 / 5; }
  [zoom=6] { line-width: 17 / 5; }
  [zoom=7] { line-width: 23 / 5; }
  [zoom=8] { line-width: 30 / 5; }
  [zoom=9] { line-width: 38 / 5; }
  [zoom>9] { line-width: 47 / 5; }
  image-filters: agg-stack-blur(6,6);
}

#parties::nahdhanumbers {
    text-name:'[ratio_nc]';
    text-face-name:'Futura Condensed Medium';
    text-fill:#fff;
    //text-dy:-20;
  [zoom=3] { 
    [ratio_n<=5]{ text-size:(@c1 * 3); }
    [ratio_n>5] { text-size:(@c2 * 3); }
    [ratio_n>10] { text-size:(@c3 * 3); }
    [ratio_n>15] { text-size:(@c4 * 3); }
    [ratio_n>20]{ text-size:(@c5 * 3); }
    [ratio_n>25]{ text-size:(@c6 * 3); }
  }
  [zoom=4] { 
    [ratio_n<=5]{ text-size:(@c1 * 4); }
    [ratio_n>5] { text-size:(@c2 * 4); }
    [ratio_n>10] { text-size:(@c3 * 4); }
    [ratio_n>15] { text-size:(@c4 * 4); }
    [ratio_n>20]{ text-size:(@c5 * 4); }
    [ratio_n>25]{ text-size:(@c6 * 4); }
  }
  [zoom=5] { 
    [ratio_n<=5]{ text-size:(@c1 * 5); }
    [ratio_n>5] { text-size:(@c2 * 5); }
    [ratio_n>10] { text-size:(@c3 * 5); }
    [ratio_n>15] { text-size:(@c4 * 5); }
    [ratio_n>20]{ text-size:(@c5 * 5); }
    [ratio_n>25]{ text-size:(@c6 * 5); }
  }
  [zoom=6] { 
    [ratio_n<=5]{ text-size:(@c1 * 6); }
    [ratio_n>5] { text-size:(@c2 * 6); }
    [ratio_n>10] { text-size:(@c3 * 6); }
    [ratio_n>15] { text-size:(@c4 * 6); }
    [ratio_n>20]{ text-size:(@c5 * 6); }
    [ratio_n>25]{ text-size:(@c6 * 6); }
  }
  [zoom=7] { 
    [ratio_n<=5]{ text-size:(@c1 * 7); }
    [ratio_n>5] { text-size:(@c2 * 7); }
    [ratio_n>10] { text-size:(@c3 * 7); }
    [ratio_n>15] { text-size:(@c4 * 7); }
    [ratio_n>20]{ text-size:(@c5 * 7); }
    [ratio_n>25]{ text-size:(@c6 * 7); }
  }
  [zoom=8] { 
    [ratio_n<=5]{ text-size:(@c1 * 8); }
    [ratio_n>5] { text-size:(@c2 * 8); }
    [ratio_n>10] { text-size:(@c3 * 8); }
    [ratio_n>15] { text-size:(@c4 * 8); }
    [ratio_n>20]{ text-size:(@c5 * 8); }
    [ratio_n>25]{ text-size:(@c6 * 8); }
  }
  [zoom=9] { 
    [ratio_n<=5]{ text-size:(@c1 * 9); }
    [ratio_n>5] { text-size:(@c2 * 9); }
    [ratio_n>10] { text-size:(@c3 * 9); }
    [ratio_n>15] { text-size:(@c4 * 9); }
    [ratio_n>20]{ text-size:(@c5 * 9); }
    [ratio_n>25]{ text-size:(@c6 * 9); }
  }
  [zoom=10]{ 
    [ratio_n<=5]{ text-size:(@c1 * 9.5); }
    [ratio_n>5] { text-size:(@c2 * 9.5); }
    [ratio_n>10] { text-size:(@c3 * 9.5); }
    [ratio_n>15] { text-size:(@c4 * 9.5); }
    [ratio_n>20]{ text-size:(@c5 * 9.5); }
    [ratio_n>25]{ text-size:(@c6 * 9.5); }
  }
  [zoom=11]{ 
    [ratio_n<=5]{ text-size:(@c1 * 10); }
    [ratio_n>5] { text-size:(@c2 * 10); }
    [ratio_n>10] { text-size:(@c3 * 10); }
    [ratio_n>15] { text-size:(@c4 * 10); }
    [ratio_n>20]{ text-size:(@c5 * 10); }
    [ratio_n>25]{ text-size:(@c6 * 10); }
  }
 [zoom=12]{ 
    [ratio_n<=5]{ text-size:(@c1 * 10.5); }
    [ratio_n>5] { text-size:(@c2 * 10.5); }
    [ratio_n>10]{ text-size:(@c3 * 10.5); }
    [ratio_n>15]{ text-size:(@c4 * 10.5); }
    [ratio_n>20]{ text-size:(@c5 * 10.5); }
    [ratio_n>25]{ text-size:(@c6 * 10.5); }
  }
}
*/