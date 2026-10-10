local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  -- Basic document environment
  s("doc", {
    t({"\\documentclass{article}", "", "\\begin{document}", "\t"}),
    i(1, "Your content here"),
    t({"", "\\end{document}"})
  }),

  -- Bold text
  s("bold", {
    t("\\textbf{"),
    i(1, "text"),
    t("}")
  }),

  -- Math environment
  s("math", {
    t("$"),
    i(1),
    t("$")
  }),

  -- Figure environment (simplified)
  s("fig", {
    t({"\\begin{figure}[!ht]",
       "  \\centering",
       "  \\includegraphics[width="}),
    i(1, "0.95\\textwidth"),
    t("]{"),
    i(2, "image"),
    t({"}", 
       "  \\caption{"}),
    i(3, "Caption"),
    t({"}", 
       "  \\label{fig:"}),
    i(4, "label"),
    t({"}", 
       "\\end{figure}"})
  }),

  -- Itemize environment
  s("item", {
    t({"\\begin{itemize}",
       "  \\item "}),
    i(1),
    t({"", "  \\item "}),
    i(2),
    t({"", "\\end{itemize}"})
  }),
s("em", {
  t("\\emph{"),
  i(1, "text"),
  t("}"),
}),
  s("mintpy", {
    t({"\\begin{minted}{python}", "\t"}),
    i(1, "-- code here --"),
    t({"", "\\end{minted}"}),
  }),}


