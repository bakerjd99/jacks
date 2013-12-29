{- This module was generated from data in the Kate syntax
   highlighting file j.xml, version 1.0, by Igor Zhuravlov (zhuravlov.ip@it.dvfu.ru) -}

module Text.Highlighting.Kate.Syntax.J
          (highlight, parseExpression, syntaxName, syntaxExtensions)
where
import Text.Highlighting.Kate.Types
import Text.Highlighting.Kate.Common
import Text.ParserCombinators.Parsec hiding (State)
import Control.Monad.State
import Data.Char (isSpace)
import Data.Maybe (fromMaybe)

-- | Full name of language.
syntaxName :: String
syntaxName = "J"

-- | Filename extensions for this language.
syntaxExtensions :: String
syntaxExtensions = "*.ijs;*.IJS"

-- | Highlight source code using this syntax definition.
highlight :: String -> [SourceLine]
highlight input = evalState (mapM parseSourceLine $ lines input) startingState

parseSourceLine :: String -> State SyntaxState SourceLine
parseSourceLine = mkParseSourceLine parseExpression

-- | Parse an expression using appropriate local context.
parseExpression :: KateParser Token
parseExpression = do
  (lang,cont) <- currentContext
  result <- parseRules (lang,cont)
  optional $ do eof
                updateState $ \st -> st{ synStPrevChar = '\n' }
                pEndLine
  return result

startingState = SyntaxState {synStContexts = [("J","sentence")], synStLineNumber = 0, synStPrevChar = '\n', synStPrevNonspace = False, synStCaseSensitive = True, synStKeywordCaseSensitive = True, synStCaptures = []}

pEndLine = do
  updateState $ \st -> st{ synStPrevNonspace = False }
  context <- currentContext
  case context of
    ("J","sentence") -> return ()
    ("J","comment") -> (popContext) >> pEndLine
    _ -> return ()

withAttribute attr txt = do
  when (null txt) $ fail "Parser matched no text"
  updateState $ \st -> st { synStPrevChar = last txt
                          , synStPrevNonspace = synStPrevNonspace st || not (all isSpace txt) }
  return (attr, txt)


regex_'27'28'5b'5e'27'5d'7c'27'27'29'2a'27 = compileRegex "'([^']|'')*'"
regex_'28'5b'2f'5c'5cbfMt'5d'5c'2e'7ct'3a'7c'5b'7e'2f'5c'5c'7d'5d'29'28'3f'21'5b'2e'3a'5d'29 = compileRegex "([/\\\\bfMt]\\.|t:|[~/\\\\}])(?![.:])"
regex_'28'5f'3f'5cd'3a'7cp'5c'2e'5c'2e'7c'5bACeEIjLor'5d'5c'2e'7c'5b'5f'2f'5c'5ciqsux'5d'3a'7c'5c'7b'3a'3a'7c'5b'3d'21'5c'5d'5d'7c'5b'2d'3c'3e'2b'2a'25'24'7c'2c'23'7b'5d'5b'2e'3a'5d'3f'7c'5b'3b'5b'5d'3a'3f'7c'5b'7e'7d'22ip'5d'5b'2e'3a'5d'7c'5b'3f'5e'5d'5c'2e'3f'29'28'3f'21'5b'2e'3a'5d'29 = compileRegex "(_?\\d:|p\\.\\.|[ACeEIjLor]\\.|[_/\\\\iqsux]:|\\{::|[=!\\]]|[-<>+*%$|,#{][.:]?|[;[]:?|[~}\"ip][.:]|[?^]\\.?)(?![.:])"
regex_'5cb'5cd'2bb'5f'3f'5ba'2dz'5cd'5d'2b'28'5c'2e'5ba'2dz'5cd'5d'2b'29'5cb'7c'5cb'5f'3f'5cd'2bx'5cb'7c'5cb'5f'3f'5cd'2br'5f'3f'5cd'2b'5cb'7c'5cb'28'5f'3f'5cd'2b'28'5c'2e'5cd'2b'29'3f'28e'5cd'2b'29'3f'7c'5f'3f'5f'7c'5f'5c'2e'29'28'28j'7ca'5bdr'5d'29'28'5f'3f'5cd'2b'28'5c'2e'5cd'2b'29'3f'28e'5cd'2b'29'3f'7c'5f'3f'5f'7c'5f'5c'2e'29'29'3f'28'5bpx'5d'28'5f'3f'5cd'2b'28'5c'2e'5cd'2b'29'3f'28e'5cd'2b'29'3f'7c'5f'3f'5f'7c'5f'5c'2e'29'28'28j'7ca'5bdr'5d'29'28'5f'3f'5cd'2b'28'5c'2e'5cd'2b'29'3f'28e'5cd'2b'29'3f'7c'5f'3f'5f'7c'5f'5c'2e'29'29'3f'29'3f'28'3f'21'5ba'2dz'5cd'5f'2e'5d'29 = compileRegex "\\b\\d+b_?[a-z\\d]+(\\.[a-z\\d]+)\\b|\\b_?\\d+x\\b|\\b_?\\d+r_?\\d+\\b|\\b(_?\\d+(\\.\\d+)?(e\\d+)?|_?_|_\\.)((j|a[dr])(_?\\d+(\\.\\d+)?(e\\d+)?|_?_|_\\.))?([px](_?\\d+(\\.\\d+)?(e\\d+)?|_?_|_\\.)((j|a[dr])(_?\\d+(\\.\\d+)?(e\\d+)?|_?_|_\\.))?)?(?![a-z\\d_.])"
regex_'28'22'7c'5b'40'26'5d'5b'2e'3a'5d'3f'7c'5b'2e'3a'5d'5b'2e'3a'5d'3f'7c'5b'21D'5d'5b'2e'3a'5d'7c'26'5c'2e'3a'7c'5b'3bdHT'5d'5c'2e'7c'60'3a'3f'7c'5bLS'5e'5d'3a'29'28'3f'21'5b'2e'3a'5d'29 = compileRegex "(\"|[@&][.:]?|[.:][.:]?|[!D][.:]|&\\.:|[;dHT]\\.|`:?|[LS^]:)(?![.:])"
regex_'5cb'28assert'7cbreak'7cf'3fcase'7ccatch'5bdt'5d'3f'7ccontinue'7cdo'7celse'28if'29'3f'7cend'7cfor'28'5f'5ba'2dzA'2dZ'5d'5ba'2dzA'2dZ'5cd'5f'5d'2a'29'3f'7c'28goto'7clabel'29'5f'5ba'2dzA'2dZ'5d'5ba'2dzA'2dZ'5cd'5f'5d'2a'7cif'7creturn'7cselect'7cthrow'7ctry'7cwhil'28e'7cst'29'29'5c'2e'28'3f'21'5b'2e'3a'5d'29 = compileRegex "\\b(assert|break|f?case|catch[dt]?|continue|do|else(if)?|end|for(_[a-zA-Z][a-zA-Z\\d_]*)?|(goto|label)_[a-zA-Z][a-zA-Z\\d_]*|if|return|select|throw|try|whil(e|st))\\.(?![.:])"
regex_'5cb'5bnmuvxy'5d'5c'2e'3f'28'3f'21'5b'5cw'3a'5d'29 = compileRegex "\\b[nmuvxy]\\.?(?![\\w:])"
regex_'5cba'5b'2e'3a'5d'28'3f'21'5b'2e'3a'5d'29 = compileRegex "\\ba[.:](?![.:])"

defaultAttributes = [(("J","sentence"),NormalTok),(("J","comment"),CommentTok)]

parseRules ("J","sentence") =
  (((pDetectSpaces >>= withAttribute NormalTok))
   <|>
   ((pString False "NB." >>= withAttribute CommentTok) >>~ pushContext ("J","comment"))
   <|>
   ((pRegExpr regex_'27'28'5b'5e'27'5d'7c'27'27'29'2a'27 >>= withAttribute StringTok))
   <|>
   ((pRegExpr regex_'28'5b'2f'5c'5cbfMt'5d'5c'2e'7ct'3a'7c'5b'7e'2f'5c'5c'7d'5d'29'28'3f'21'5b'2e'3a'5d'29 >>= withAttribute KeywordTok))
   <|>
   ((pRegExpr regex_'28'5f'3f'5cd'3a'7cp'5c'2e'5c'2e'7c'5bACeEIjLor'5d'5c'2e'7c'5b'5f'2f'5c'5ciqsux'5d'3a'7c'5c'7b'3a'3a'7c'5b'3d'21'5c'5d'5d'7c'5b'2d'3c'3e'2b'2a'25'24'7c'2c'23'7b'5d'5b'2e'3a'5d'3f'7c'5b'3b'5b'5d'3a'3f'7c'5b'7e'7d'22ip'5d'5b'2e'3a'5d'7c'5b'3f'5e'5d'5c'2e'3f'29'28'3f'21'5b'2e'3a'5d'29 >>= withAttribute KeywordTok))
   <|>
   ((pRegExpr regex_'5cb'5cd'2bb'5f'3f'5ba'2dz'5cd'5d'2b'28'5c'2e'5ba'2dz'5cd'5d'2b'29'5cb'7c'5cb'5f'3f'5cd'2bx'5cb'7c'5cb'5f'3f'5cd'2br'5f'3f'5cd'2b'5cb'7c'5cb'28'5f'3f'5cd'2b'28'5c'2e'5cd'2b'29'3f'28e'5cd'2b'29'3f'7c'5f'3f'5f'7c'5f'5c'2e'29'28'28j'7ca'5bdr'5d'29'28'5f'3f'5cd'2b'28'5c'2e'5cd'2b'29'3f'28e'5cd'2b'29'3f'7c'5f'3f'5f'7c'5f'5c'2e'29'29'3f'28'5bpx'5d'28'5f'3f'5cd'2b'28'5c'2e'5cd'2b'29'3f'28e'5cd'2b'29'3f'7c'5f'3f'5f'7c'5f'5c'2e'29'28'28j'7ca'5bdr'5d'29'28'5f'3f'5cd'2b'28'5c'2e'5cd'2b'29'3f'28e'5cd'2b'29'3f'7c'5f'3f'5f'7c'5f'5c'2e'29'29'3f'29'3f'28'3f'21'5ba'2dz'5cd'5f'2e'5d'29 >>= withAttribute DecValTok))
   <|>
   ((pAnyChar "()" >>= withAttribute RegionMarkerTok))
   <|>
   ((pRegExpr regex_'28'22'7c'5b'40'26'5d'5b'2e'3a'5d'3f'7c'5b'2e'3a'5d'5b'2e'3a'5d'3f'7c'5b'21D'5d'5b'2e'3a'5d'7c'26'5c'2e'3a'7c'5b'3bdHT'5d'5c'2e'7c'60'3a'3f'7c'5bLS'5e'5d'3a'29'28'3f'21'5b'2e'3a'5d'29 >>= withAttribute KeywordTok))
   <|>
   ((pRegExpr regex_'5cb'28assert'7cbreak'7cf'3fcase'7ccatch'5bdt'5d'3f'7ccontinue'7cdo'7celse'28if'29'3f'7cend'7cfor'28'5f'5ba'2dzA'2dZ'5d'5ba'2dzA'2dZ'5cd'5f'5d'2a'29'3f'7c'28goto'7clabel'29'5f'5ba'2dzA'2dZ'5d'5ba'2dzA'2dZ'5cd'5f'5d'2a'7cif'7creturn'7cselect'7cthrow'7ctry'7cwhil'28e'7cst'29'29'5c'2e'28'3f'21'5b'2e'3a'5d'29 >>= withAttribute KeywordTok))
   <|>
   ((pDetect2Chars False '=' ':' >>= withAttribute KeywordTok))
   <|>
   ((pDetect2Chars False '=' '.' >>= withAttribute KeywordTok))
   <|>
   ((pRegExpr regex_'5cb'5bnmuvxy'5d'5c'2e'3f'28'3f'21'5b'5cw'3a'5d'29 >>= withAttribute KeywordTok))
   <|>
   ((pRegExpr regex_'5cba'5b'2e'3a'5d'28'3f'21'5b'2e'3a'5d'29 >>= withAttribute KeywordTok))
   <|>
   (currentContext >>= \x -> guard (x == ("J","sentence")) >> pDefault >>= withAttribute (fromMaybe NormalTok $ lookup ("J","sentence") defaultAttributes)))

parseRules ("J","comment") =
  (currentContext >>= \x -> guard (x == ("J","comment")) >> pDefault >>= withAttribute (fromMaybe NormalTok $ lookup ("J","comment") defaultAttributes))


parseRules x = parseRules ("J","sentence") <|> fail ("Unknown context" ++ show x)
