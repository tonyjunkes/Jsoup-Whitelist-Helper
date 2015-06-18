<cfscript>

Whitelist = createObject("java", "org.jsoup.safety.Whitelist").relaxed();
WhitelistHelper = createObject("component", "JsoupWhitelistHelper").init(Whitelist);

writeOutput("<h5>Invalid Tags</h5>");
writeDump(WhitelistHelper.getInvalidTags("<header>Hi</header><script>Hey</script><li>Hello</li>"));

writeOutput("<h5>Valid Tags</h5>");
writeDump(WhitelistHelper.getValidTags());

writeOutput("<h5>Tag Attributes</h5>");
writeDump(WhitelistHelper.getTagAttributes());

writeOutput("<h5>Tag Protocols</h5>");
writeDump(WhitelistHelper.getTagProtocols());

writeOutput("<h5>Preserved Relative Links</h5>");
writeDump(WhitelistHelper.isPreserveRelativeLinks());

writeOutput("<h5>Enforced Attributes</h5>");
Whitelist.addEnforcedAttribute("a", "href", "test.com");
writeDump(WhitelistHelper.getEnforcedAttributes());

</cfscript>