\version ""
\include "global.ly"

crescPoco = \tweak DynamicText.self-alignment-X #LEFT \tweak X-offset #0.0
#(make-dynamic-script (markup #:normal-text #:italic "cresc. poco a poco"))

rit = \tweak DynamicText.self-alignment-X #LEFT \tweak X-offset #0.0
#(make-dynamic-script (markup #:normal-text #:italic "rit."))

rall = \tweak DynamicText.self-alignment-X #LEFT \tweak X-offset #0.0
#(make-dynamic-script (markup #:normal-text #:italic "rall."))

dynamics = {
  \global
  % allow text in the dynamics block to be centered vertically
  % \override TextScript.extra-offset = #'(0 . 1)

  s

}
