%%
%% This is file `examz.cls',
%% generated with the docstrip utility.
%%
%% The original source files were:
%%
%% examz.dtx  (with options: `class')
%% 
%% This is a generated file.
%% 
%% `examz' --- 2023/05/30 Version 1.0.0
%% 
%% Copyright (C) 2023 by Christopher McClain
%% E-mail: christopher.mcclain@mail.wvu.edu
%% 
%% This file may be distributed and/or modified under the
%% conditions of the LaTeX Project Public License, either
%% version 1.3c of this license or (at your option) any later
%% version. The latest version of this license is in:
%% 
%%    http://www.latex-project.org/lppl.txt
%% 
%% and version 1.3c or later is part of all distributions of
%% LaTeX version 2008 or later.
%% 
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{examz}
    [2023/06/07 v1.0.0 Randomized exams with multiple versions]
\RequirePackage{environ}
\RequirePackage{xpatch}
\RequirePackage{counterz}
\newbool{@examz@complete}
\boolfalse{@examz@complete}
\DeclareOption{complete}{\booltrue{@examz@complete}}
\randomizectr
\DeclareOption{randomize}{\randomizectr}
\DeclareOption{norandomize}{\norandomizectr}
\newbool{@examz@prompt}
\boolfalse{@examz@prompt}
\DeclareOption{prompt}{\booltrue{@examz@prompt}}
\newcommand{\promptrandomexam}{%
   \promptrandomizectr[\EnterResponse]{%
      ^^J Enter 1 to randomize document.
      ^^J Enter 2 to update without new randomization.
   }{%
      1%
   }%
}%
\DeclareOption*{%
   \PassOptionsToClass{\CurrentOption}{exam}
}%
\ProcessOptions\relax
\LoadClass{exam}
\xpatchcmd{\endcoverpages}{\setcounter{num@coverpages}{\value{page}}}{%
   \ifbool{@twoside}{%
      \ifnumodd{\value{page}}{%
         % Do Nothing
      }{%
         \newpage
         \null
         \newpage
      }%
   }{%
      % Do nothing
   }%
   \setcounter{num@coverpages}{\value{page}}%
}{}{}%
\AtBeginDocument{%
   \ifbool{@examz@prompt}{%
      \promptrandomexam
   }{%
   }%
   \ifrandomizectr{%
      \opencountersfile
   }{%
      \inputcountersfile
   }%
}%
\newcounter{numversions}
\setcounter{numversions}{1}
\newcommand{\promptversions}{%
   \typein[\NumberOfVersions]{%
      ^^J How many versions?
   }%
   \setcounter{numversions}{\NumberOfVersions}
   \savecounter{numversions}
}%
\newcounter{version}
\setcounter{version}{1}
\xpatchcmd{\find@latestques}
   {@\arabic{question}}
   {@\arabic{version}\ifbool{printanswers}{S}{}@\arabic{question}}
   {}{}
\xpatchcmd{\decr@latest@ques}
   {question@}
   {question@\arabic{version}\ifbool{printanswers}{S}{}@}
   {}{}
\xpatchcmd{\chk@incompi}
   {question@}
   {question@\arabic{version}\ifbool{printanswers}{S}{}@}
   {}{}
\xpatchcmd{\questions}
   {@\arabic{question}}
   {@\arabic{version}\ifbool{printanswers}{S}{}@\arabic{question}}
   {}{}
\xpatchcmd{\parts}
   {@\arabic{question}}
   {@\arabic{version}\ifbool{printanswers}{S}{}@\arabic{question}}
   {}{}
\xpatchcmd{\subparts}
   {@\arabic{question}}
   {@\arabic{version}\ifbool{printanswers}{S}{}@\arabic{question}}
   {}{}
\xpatchcmd{\subsubparts}
   {@\arabic{question}}
   {@\arabic{version}\ifbool{printanswers}{S}{}@\arabic{question}}
   {}{}
\xpatchcmd{\setup@point@toks}
   {@\arabic{question}}
   {@\arabic{version}\ifbool{printanswers}{S}{}@\arabic{question}}
   {}{}
\xpatchcmd{\refto@index}
   {question@}
   {question@\arabic{version}\ifbool{printanswers}{S}{}@}
   {}{}
\newcommand{\@examz@versions}[1]{%
   \ifrandomizectr{%
      \ifbool{@examz@prompt}{%
         \promptversions
      }{%
         % Do Nothing
      }%
   }{%
      % Do Nothing
   }%
   \ifbool{@examz@complete}{%
      \noprintanswers
   }{%
      % Do Nothing
   }%
   \whileboolexpr{%
      test{\ifnumless{\value{version}}{1+\value{numversions}}}
   }{%
      \ifbool{@twoside}{%
         \ifnumodd{\value{page}}{%
            % Do Nothing
         }{%
            \newpage
            \null
            \thispagestyle{empty}
            \newpage
         }%
      }{%
         % Do Nothing
      }%
      \setcounter{page}{1}
      \setcounter{numquestions}{0}
      \setcounter{numparts}{0}
      \setcounter{numsubparts}{0}
      \setcounter{numsubsubparts}{0}
      \setcounter{numpoints}{0}
      \setcounter{numbonuspoints}{0}
      #1
      \newpage
      \notbool{@examz@complete}{%
         \addtocounter{version}{1}
      }{%
         \notbool{printanswers}{%
            \printanswers
         }{%
            \noprintanswers
            \addtocounter{version}{1}
         }%
      }%
   }%
}%
\newenvironment{versions}[1][1]{%
   \ifrandomizectr{%
      \setcounter{numversions}{#1}
      \savecounter{numversions}
   }{%
      % Do Nothing
   }%
   \Collect@Body\@examz@versions
}{%
   % Empty
}%
\AtEndDocument{%
   \typeout{%
      This document contains \thenumversions\space
      version\ifnumequal{\value{numversions}}{1}{}{s} of the exam
      \ifbool{@examz@complete}{%
         with and without solutions.
      }{%
         \ifbool{printanswers}{%
            with solutions.
         }{%
            without solutions.
         }%
      }%
   }%
}%
\newcommand{\@examz@questionpath}{}
\newcommand{\setquestionpath}[1]{%
   \renewcommand{\@examz@questionpath}{#1}
}%
\newcommand{\questionfrombank}[2][]{%
   \question[#1]
   \setcounterprefix{#2_Version_\arabic{version}_}
   \input{\@examz@questionpath #2}
   \clearcounterprefix
}%
\newcounter{@examz@qbsize}
\newcommand{\setnumberofquestions}[1]{%
   \setcounter{@examz@qbsize}{#1}
}%
\newenvironment{questionbank}{%
   \xrandprovidecounter{Random_Question}{1}{\value{@examz@qbsize}}
}{%
   \endinput
}
\NewEnviron{qbitem}[1]{%
\ifnumequal{\xvalue{Random_Question}}{#1}{%
\BODY
}{%
}
}
\newcommand{\@examz@solutionspace}{1cm}
\newcommand{\setsolutionspace}[1]{%
   \renewcommand{\@examz@solutionspace}{#1}
}%
\NewEnviron{qbsolution}{%
   \begin{solution}[\@examz@solutionspace]
      \BODY
   \end{solution}
}%
\NewEnviron{qbsolutionbox}{%
\begin{solutionbox}{\@examz@solutionspace}
\BODY
\end{solutionbox}
}%
\NewEnviron{qbsolutionorbox}{%
\begin{solutionorbox}[\@examz@solutionspace]
\BODY
\end{solutionorbox}
}%
\NewEnviron{qbsolutionorlines}{%
\begin{solutionorlines}[\@examz@solutionspace]
\BODY
\end{solutionorlines}
}%
\NewEnviron{qbsolutionordottedlines}{%
\begin{solutionordottedlines}[\@examz@solutionspace]
\BODY
\end{solutionordottedlines}
}%
\NewEnviron{qbsolutionorgrid}{%
\begin{solutionorgrid}[\@examz@solutionspace]
\BODY
\end{solutionorgrid}
}%
\newcommand{\instructorname}{Instructor Name}
\newcommand{\coursename}{Course Name}
\newcommand{\examname}{Exam Name}
\newcommand{\termname}{Term Name}
\newcommand{\namespace}{Name:~\makebox[5cm]{\hrulefill}}
\newcommand{\instructions}{Instructions Here}
\newcommand{\covernoanswers}{}
\newcommand{\coveranswers}{\covernoanswers}
\newcommand{\workspace}{}
\newcommand{\setinstructorname}[1]{\renewcommand{\instructorname}{#1}}
\newcommand{\setcoursename}[1]{\renewcommand{\coursename}{#1}}
\newcommand{\setexamname}[1]{\renewcommand{\examname}{#1}}
\newcommand{\settermname}[1]{\renewcommand{\termname}{#1}}
\newcommand{\setnamespace}[1]{\renewcommand{\namespace}{#1}}
\newcommand{\setinstructions}[1]{\renewcommand{\instructions}{#1}}
\newcommand{\setcovernoanswers}[1]{\renewcommand{\covernoanswers}{#1}}
\newcommand{\setcoveranswers}[1]{\renewcommand{\coveranswers}{#1}}
\newcommand{\setworkspace}[1]{\renewcommand{\workspace}{#1}}
\newcommand{\printcover}{%
   \ifbool{printanswers}{\coveranswers}{\covernoanswers}
}%
\newcommand{\printworkspace}{%
   \ifbool{printanswers}{}{\workspace}
}%
\endinput
%%
%% End of file `examz.cls'.
