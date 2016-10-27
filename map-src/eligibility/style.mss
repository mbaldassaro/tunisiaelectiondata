// --- variables --------------------- 
// these make changing the relative sizes of 
// text labels much easier than changing 
// the same six values for each of the 9 zoom levels styled

@c1: 1.5 - 0.5;
@c2: 2.5 - 0.5;
@c3: 3.0 - 0.5;
@c4: 3.5 - 0.5;
@c5: 4.0 - 0.5;
@c6: 4.5 - 0.5;

#eligibility {
// --- polygon fill --------------------- 
  
  // fade in polygons
  [zoom<=5] { line-opacity:0; } 
  [zoom=6] { line-opacity:.1; }
  [zoom=7] { line-opacity:.25; }
  [zoom>7] { line-opacity:.55; }
  line-color:#faa;
  line-width:.5;
  line-dasharray:2,8;
  polygon-opacity:.075;
  polygon-fill:#f32;
  // we want a gray fill for delegations with no data
  [ratio_c='n/a'] { polygon-fill:#555; polygon-opacity:.5;}
  
// --- labels --------------------------- 
  text-name:'[ratio_c]';
  text-face-name:'Futura Condensed Medium';
  text-fill:#fff;
  [zoom=3] { 
    [ratio<=30]{ text-size:(@c1 * 3); }
    [ratio>30] { text-size:(@c2 * 3); }
    [ratio>40] { text-size:(@c3 * 3); }
    [ratio>50] { text-size:(@c4 * 3); }
    [ratio>60] { text-size:(@c5 * 3); }
    [ratio>70] { text-size:(@c6 * 3); }
  }
  [zoom=4] { 
    [ratio<=10]{ text-size:(@c1 * 4); }
    [ratio>10] { text-size:(@c2 * 4); }
    [ratio>20] { text-size:(@c3 * 4); }
    [ratio>30] { text-size:(@c4 * 4); }
    [ratio>40] { text-size:(@c5 * 4); }
    [ratio>50] { text-size:(@c6 * 4); }
  }
  [zoom=5] { 
    [ratio<=10]{ text-size:(@c1 * 5); }
    [ratio>10] { text-size:(@c2 * 5); }
    [ratio>20] { text-size:(@c3 * 5); }
    [ratio>30] { text-size:(@c4 * 5); }
    [ratio>40] { text-size:(@c5 * 5); }
    [ratio>50] { text-size:(@c6 * 5); }
  }
  [zoom=6] { 
    [ratio<=10]{ text-size:(@c1 * 6); }
    [ratio>10] { text-size:(@c2 * 6); }
    [ratio>20] { text-size:(@c3 * 6); }
    [ratio>30] { text-size:(@c4 * 6); }
    [ratio>40] { text-size:(@c5 * 6); }
    [ratio>50] { text-size:(@c6 * 6); }
  }
  [zoom=7] { 
    [ratio<=10]{ text-size:(@c1 * 7); }
    [ratio>10] { text-size:(@c2 * 7); }
    [ratio>20] { text-size:(@c3 * 7); }
    [ratio>30] { text-size:(@c4 * 7); }
    [ratio>40] { text-size:(@c5 * 7); }
    [ratio>50] { text-size:(@c6 * 7); }
  }
  [zoom=8] { 
    [ratio<=10]{ text-size:(@c1 * 8); }
    [ratio>10] { text-size:(@c2 * 8); }
    [ratio>20] { text-size:(@c3 * 8); }
    [ratio>30] { text-size:(@c4 * 8); }
    [ratio>40] { text-size:(@c5 * 8); }
    [ratio>50] { text-size:(@c6 * 8); }
  }
  [zoom=9] { 
    [ratio<=10]{ text-size:(@c1 * 9); }
    [ratio>10] { text-size:(@c2 * 9); }
    [ratio>20] { text-size:(@c3 * 9); }
    [ratio>30] { text-size:(@c4 * 9); }
    [ratio>40] { text-size:(@c5 * 9); }
    [ratio>50] { text-size:(@c6 * 9); }
  }
  [zoom=10]{ 
    [ratio<=10]{ text-size:(@c1 * 9.5); }
    [ratio>10] { text-size:(@c2 * 9.5); }
    [ratio>20] { text-size:(@c3 * 9.5); }
    [ratio>30] { text-size:(@c4 * 9.5); }
    [ratio>40] { text-size:(@c5 * 9.5); }
    [ratio>50] { text-size:(@c6 * 9.5); }
  }
  [zoom=11]{ 
    [ratio<=10]{ text-size:(@c1 * 10); }
    [ratio>10] { text-size:(@c2 * 10); }
    [ratio>20] { text-size:(@c3 * 10); }
    [ratio>30] { text-size:(@c4 * 10); }
    [ratio>40] { text-size:(@c5 * 10); }
    [ratio>50] { text-size:(@c6 * 10); }
  }
  [zoom=12]{ 
    [ratio<=10]{ text-size:(@c1 * 10.5); }
    [ratio>10] { text-size:(@c2 * 10.5); }
    [ratio>20] { text-size:(@c3 * 10.5); }
    [ratio>30] { text-size:(@c4 * 10.5); }
    [ratio>40] { text-size:(@c5 * 10.5); }
    [ratio>50] { text-size:(@c6 * 10.5); }
  }
}

// --- borders look better with a little glow --- 
// see  

#delratio::glow {
  polygon-opacity:0;
  opacity: 0.15;
  line-join: round;
  line-color:#ddd;
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
