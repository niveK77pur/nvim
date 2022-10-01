% use the following to make a "tag" that will be looked
% for when using the function FromTemplate(<NAME>)
% defined in the lilypond.ly ftplugin file.
%
%                   %$<NAME> +<LINES>
%
% Where <NAME> is the name of the tag and <LINES> specifies
% how many more lines right after the tag need to be taken
% for the template.

%~~~~~~~~~~~~~~~~~~~~~~~~~
%     Multiple Voices
%~~~~~~~~~~~~~~~~~~~~~~~~~

% ~~~ Temporary polyphonic passages ~~~
%$TempPoly +6
<< { \voiceOne 
    [>VIM<]
  }
  \new Voice { \voiceTwo 
    [>VIM<]
  }
>> \oneVoice

% ~~~ The double backslash construct ~~~
%$DoublePoly1 +0
<< { [>VIM<] } \\ { [>VIM<] } >>
%$DoublePoly2 +4
<<
  { [>VIM<] }
  \\
  { [>VIM<] }
>>
