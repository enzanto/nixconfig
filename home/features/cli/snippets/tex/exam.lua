local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

return{
	s("examstep", {
		i(1, "No."), t(" & "), t({"",
	""}),
		i(2, "Description"), t({"", 
		"\\\\ \\hline"})
	}),
	-- exam step with figure
  s("examstepfig", {
    -- Step number
    i(1, "No."), t(" & "), t({"", 
      "  \\begin{minipage}{0.85\\textwidth}", 
	  "    \\vspace{0.2em}",
      "    "}),
    
    -- Description text (two sentences)
    i(2, "Description"),  t({"", "",
      "    \\begin{figure}[H]",
      "      \\centering",
      "      \\includegraphics[width=\\linewidth]{"}),
    
    -- Image path (without extension)
    i(3, "example-screenshot"), t({"}", "",
      "      \\caption["}),
    
    -- Caption with citation placeholder
    i(4, "short-citation"), t("]{"), i(5, "long citation"),  t(" \\parencite{"), i(6, "citation-key"), t({"}.}", "",
      "      \\label{fig:"}), i(7, "shortlabel"),
    
    -- Label
    f(function(args) 
      return "step" .. args[1][1]  -- Combines step number with "step"
    end, {1}), t({"}", "",
      "    \\end{figure}", 
      "  \\end{minipage} \\\\ \\hline"})
  })
}


