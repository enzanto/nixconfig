-- ~/.config/nixvim/lua/snippets/markdown.lua
return {
  -- Regular snippet
  s("manp", {
    t("> [!info]- Man Pages"),
    t({"", "> "}),
    i(0),
  }),

  -- Autosnippet (auto-triggers without pressing Tab)
  parse("automanp", "> [!info]- Auto Man Pages\n> $0"),
}, {
  -- Second table: autosnippets only
  s("auto_manp", {
    t("> [!auto]- Auto Expanded"),
    t({"", "> "}),
    i(0),
  }),
}
