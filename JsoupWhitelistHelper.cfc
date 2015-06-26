component displayname="Jsoup Whitelist Helper"
	output="false"
{
	public JsoupWhitelistHelper function init(required any whitelist) {
		variables.Jsoup = createObject("java", "org.jsoup.Jsoup");
		if (isWhitelist(arguments.whitelist)) {
			variables.Whitelist = arguments.whitelist;
		} else {
			throw("Not a valid [org.jsoup.safety.Whitelist] object.");
		}

		return this;
	}

	public array function getInvalidTags(required string content) {
		var results = [];
		var elements = variables.Jsoup.parse(arguments.content).body().select("*");
		for (var element in elements) {
			var tag = chr(60) & element.tagName() & chr(62);
			if (!variables.Jsoup.isValid(tag, variables.Whitelist)) {
				arrayAppend(results, tag);
			}
		}

		return results;
	}

	public array function getValidTags() {
		var results = [];
		var tags = variables.Whitelist.getClass().getDeclaredField("tagNames");
		tags.setAccessible(true);
		for (var tag in tags.get(variables.Whitelist).toArray()) {
			arrayAppend(results, tag.toString());
		}

		return results;
	}

	public array function getTagAttributes() {
		var results = [];
		var attr = variables.Whitelist.getClass().getDeclaredField("attributes");
		attr.setAccessible(true);
		var it = attr.get(variables.Whitelist).entrySet().iterator();
		while (it.hasNext()) {
		    var element = it.next();
		    var values = [];
		    for (var value in element.getValue().toArray()) {
		    	arrayAppend(values, value.toString());
		    }
		    arrayAppend(results, {"element": element.getKey().toString(), "attributes": values});
		}

		return results;
	}

	public array function getEnforcedAttributes() {
		var results = [];
		var ea = variables.Whitelist.getClass().getDeclaredField("enforcedAttributes");
		ea.setAccessible(true);
		var ea_it = ea.get(variables.Whitelist).entrySet().iterator();
		while (ea_it.hasNext()) {
			var tag = ea_it.next();
			var a_it = tag.getValue().entrySet().iterator();
			var element = {};
			while (a_it.hasNext()) {
				var attr = a_it.next();
				element[tag.getKey().toString()] = {
					"attribute": attr.getKey().toString(),
					"value": attr.getValue().toString()
				};
				arrayAppend(results, element);
			}
		}

		return results;
	}

	public array function getTagProtocols() {
		var results = [];
		var protocols = variables.Whitelist.getClass().getDeclaredField("protocols");
		protocols.setAccessible(true);
		var p_it = protocols.get(variables.Whitelist).entrySet().iterator();
		while (p_it.hasNext()) {
			var element = p_it.next();
			var a_it = element.getValue().entrySet().iterator();
			var values = [];
			while (a_it.hasNext()) {
				var attribute = a_it.next();
				for (value in attribute.getValue().toArray()) {
					arrayAppend(values, value.toString());
				}
				arrayAppend(results, {
					"element": element.getKey().toString(),
					"attribute": attribute.getKey().toString(),
					"protocols": values
				});
			}
		}

		return results;
	}

	public boolean function isPreserveRelativeLinks() {
		var result = variables.Whitelist.getClass().getDeclaredField("preserveRelativeLinks");
		result.setAccessible(true);
		
		return result.get(variables.Whitelist).toString();
	}

	private boolean function isWhitelist(required any whitelist) {
		return arguments.whitelist.getClass().getName() == "org.jsoup.safety.Whitelist";
	}
}
