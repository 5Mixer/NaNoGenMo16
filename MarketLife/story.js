(function (console) { "use strict";
var $estr = function() { return js_Boot.__string_rec(this,''); };
var GrammarElement = function() { };
GrammarElement.__name__ = true;
var BaseGrammarElement = function(text,hoverText) {
	this.textElement = text;
	this.hoverElement = hoverText;
};
BaseGrammarElement.__name__ = true;
BaseGrammarElement.__interfaces__ = [GrammarElement];
BaseGrammarElement.prototype = {
	text: function() {
		return this.textElement;
	}
	,hover: function() {
		return this.hoverElement;
	}
};
var CharacterElement = function(character) {
	this["char"] = character;
};
CharacterElement.__name__ = true;
CharacterElement.__interfaces__ = [GrammarElement];
CharacterElement.prototype = {
	text: function() {
		return "<b>" + this["char"].name + "</b>";
	}
	,hover: function() {
		return "\r\n\t\t\tName: " + this["char"].name + ". <br>\r\n\t\t\tProfession: " + this["char"].job.name + ". <br>\r\n\t\t\tMoney: $" + this["char"].money + "<br>\r\n\t\t\tBuys: " + this.listArrayOfStrings(this["char"].job.buysItems) + ". <br>\r\n\t\t\tSells: " + this.printItems(this["char"].job.sellsItems) + ".\r\n\t\t\tInventory: " + this.printItems(this["char"].inventory) + "<br>\r\n\t\t";
	}
	,listArrayOfStrings: function(array) {
		var a = "";
		var _g = 0;
		while(_g < array.length) {
			var i = array[_g];
			++_g;
			a += i + ", ";
		}
		return a;
	}
	,printItems: function(inv) {
		var a = "";
		var _g = 0;
		while(_g < inv.length) {
			var item = inv[_g];
			++_g;
			a += item.pluralIdentifier + " " + item.name + ", ";
		}
		return a;
	}
};
var ItemElement = function(item) {
	this.item = item;
};
ItemElement.__name__ = true;
ItemElement.__interfaces__ = [GrammarElement];
ItemElement.prototype = {
	text: function() {
		return "<b>" + this.item.pluralIdentifier + " " + this.item.name + "</b>";
	}
	,hover: function() {
		return "\r\n\t\t\tvalue: $" + this.item.value + "\r\n\t\t";
	}
};
var Grammar = function() { };
Grammar.__name__ = true;
Grammar.out = function(what) {
	var _g = 0;
	while(_g < what.length) {
		var element = what[_g];
		++_g;
		if(element.hover() != null && element.hover() != "") window.document.getElementById("market").innerHTML += "<span class='tooltipProvider'>\r\n\t\t\t\t\t" + element.text() + "\r\n\t\t\t\t\t<span class='tooltip'>\r\n\t\t\t\t\t\t" + element.hover() + "\r\n\r\n\t\t\t\t\t</span>\r\n\t\t\t\t</span>"; else window.document.getElementById("market").innerHTML += element.text();
		Grammar.wc += element.text().split(" ").length;
	}
	window.document.getElementById("market").innerHTML += "<br/>";
};
var HxOverrides = function() { };
HxOverrides.__name__ = true;
HxOverrides.indexOf = function(a,obj,i) {
	var len = a.length;
	if(i < 0) {
		i += len;
		if(i < 0) i = 0;
	}
	while(i < len) {
		if(a[i] === obj) return i;
		i++;
	}
	return -1;
};
var Weather = { __ename__ : true, __constructs__ : ["Sunny","Warm","Cold","Rainy"] };
Weather.Sunny = ["Sunny",0];
Weather.Sunny.toString = $estr;
Weather.Sunny.__enum__ = Weather;
Weather.Warm = ["Warm",1];
Weather.Warm.toString = $estr;
Weather.Warm.__enum__ = Weather;
Weather.Cold = ["Cold",2];
Weather.Cold.toString = $estr;
Weather.Cold.__enum__ = Weather;
Weather.Rainy = ["Rainy",3];
Weather.Rainy.toString = $estr;
Weather.Rainy.__enum__ = Weather;
var Main = function() {
	this.tickMax = 10;
	this.ticks = 0;
	this.characters = [];
	this.jobs = [{ name : "farmer", buysItems : ["Wood","Bread","Pig"], sellsItems : [{ name : "Wheat", pluralIdentifier : "some", value : 1},{ name : "Pig", pluralIdentifier : "a", value : 6}]},{ name : "baker", buysItems : ["Wheat"], sellsItems : [{ name : "Bread", pluralIdentifier : "some", value : 3}]},{ name : "blacksmith", buysItems : ["Steel"], sellsItems : [{ name : "Pickaxe", pluralIdentifier : "a", value : 5},{ name : "Hammer", pluralIdentifier : "a", value : 5}]},{ name : "miner", buysItems : ["Pickaxe"], sellsItems : [{ name : "Steel", pluralIdentifier : "some", value : 5}]}];
	this.day = { weather : Weather.Sunny};
	Grammar.out([new BaseGrammarElement("You set up your stall and prepare to sell goods.")]);
	var _g = 0;
	while(_g < 15) {
		var i = _g++;
		this.characters.push(this.createCharacter());
	}
	this.tick();
};
Main.__name__ = true;
Main.main = function() {
	new Main();
};
Main.prototype = {
	createCharacter: function() {
		var bnames = ["Steve","Harry","John","Peter","Joshua","Jordan","Daniel","Aaron","Adam","Jacob","Kevin","Matthew","Liam","Alexander","Ethan","Blake","Robert","Tyler"];
		var gnames = ["Chloe","Emily","Emma","Jennifer","Hannah","Amy","Nicole","Alice","Ella","Olivia","Grace","Megan","Madison","Bella","Natalia"];
		var job = this.jobs[Math.floor(Math.random() * this.jobs.length)];
		var name = "";
		if(job.name == "baker") {
			if(Math.random() > .5) name = gnames[Math.floor(Math.random() * gnames.length)]; else name = bnames[Math.floor(Math.random() * bnames.length)];
		} else name = bnames[Math.floor(Math.random() * bnames.length)];
		return { name : name, job : job, inventory : [], money : 5 + Math.round(Math.random() * 15)};
	}
	,tick: function() {
		var _g = this;
		this.ticks++;
		Grammar.out([new BaseGrammarElement("<h1>Day " + this.ticks + "</h1>")]);
		var yesterday = this.day;
		if(this.day.weather == Weather.Sunny) {
			if(Math.random() > .6) this.day.weather = Weather.Warm;
		} else if(this.day.weather == Weather.Warm) {
			if(Math.random() > .6) this.day.weather = Weather.Sunny;
			if(Math.random() < .4) this.day.weather = Weather.Cold;
		} else if(this.day.weather == Weather.Cold) {
			if(Math.random() > .6) this.day.weather = Weather.Warm;
			if(Math.random() < .4) this.day.weather = Weather.Rainy;
		} else if(this.day.weather == Weather.Rainy) {
			if(Math.random() > .6) this.day.weather = Weather.Cold;
		}
		var sales = 0;
		var saleLikelyHoodMultiplier = 1.0;
		if(this.day.weather == Weather.Sunny) saleLikelyHoodMultiplier = 1.0; else if(this.day.weather == Weather.Warm) saleLikelyHoodMultiplier = .8; else if(this.day.weather == Weather.Cold) saleLikelyHoodMultiplier = .6; else if(this.day.weather == Weather.Rainy) saleLikelyHoodMultiplier = .5;
		var _g1 = 0;
		var _g11 = this.characters;
		while(_g1 < _g11.length) {
			var character = _g11[_g1];
			++_g1;
			if(character.money < 3) {
				var victim = this.characters[Math.floor(Math.random() * this.characters.length)];
				var amount = Math.floor(Math.min(Math.max(0,victim.money),Math.floor(Math.random() * 6) + 1));
				character.money += amount;
				victim.money -= amount;
				Grammar.out([new BaseGrammarElement("With not enough coin to buy even bread, "),new CharacterElement(character),new BaseGrammarElement(" the " + character.job.name + " stole " + amount + " coins from "),new CharacterElement(victim),new BaseGrammarElement(" the " + victim.job.name + ", leaving them with " + victim.money + " coins!")]);
			}
			var _g2 = 0;
			var _g3 = this.characters;
			while(_g2 < _g3.length) {
				var character2 = _g3[_g2];
				++_g2;
				var _g4 = 0;
				var _g5 = character.job.sellsItems;
				while(_g4 < _g5.length) {
					var item = _g5[_g4];
					++_g4;
					var _g6 = 0;
					var _g7 = character2.job.buysItems;
					while(_g6 < _g7.length) {
						var buys = _g7[_g6];
						++_g6;
						if(buys == item.name) {
							if(Math.random() > 0.4 * saleLikelyHoodMultiplier) continue;
							if(item.value < character2.money) {
								Grammar.out([new CharacterElement(character),new BaseGrammarElement(" the " + character.job.name + " sold "),new ItemElement(item),new BaseGrammarElement(" to "),new CharacterElement(character2),new BaseGrammarElement(" the " + character2.job.name)]);
								sales++;
								character.inventory.splice(HxOverrides.indexOf(character.inventory,item,0),1);
								character2.inventory.push(item);
								character2.money -= item.value;
								character.money += item.value;
							}
						}
					}
				}
			}
		}
		Grammar.out([new BaseGrammarElement("Today was " + Std.string(this.day.weather) + ". There was " + sales + " trades.")]);
		Grammar.out([new BaseGrammarElement("<br><br>")]);
		var button;
		var _this = window.document;
		button = _this.createElement("button");
		button.textContent = "New day";
		button.onclick = function(_) {
			console.log("Cku");
			_g.tick();
		};
		window.document.getElementById("market").appendChild(button);
		if(this.ticks < this.tickMax) this.tick();
	}
};
Math.__name__ = true;
var Std = function() { };
Std.__name__ = true;
Std.string = function(s) {
	return js_Boot.__string_rec(s,"");
};
var js_Boot = function() { };
js_Boot.__name__ = true;
js_Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str2 = o[0] + "(";
				s += "\t";
				var _g1 = 2;
				var _g = o.length;
				while(_g1 < _g) {
					var i1 = _g1++;
					if(i1 != 2) str2 += "," + js_Boot.__string_rec(o[i1],s); else str2 += js_Boot.__string_rec(o[i1],s);
				}
				return str2 + ")";
			}
			var l = o.length;
			var i;
			var str1 = "[";
			s += "\t";
			var _g2 = 0;
			while(_g2 < l) {
				var i2 = _g2++;
				str1 += (i2 > 0?",":"") + js_Boot.__string_rec(o[i2],s);
			}
			str1 += "]";
			return str1;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString && typeof(tostr) == "function") {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js_Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
};
if(Array.prototype.indexOf) HxOverrides.indexOf = function(a,o,i) {
	return Array.prototype.indexOf.call(a,o,i);
};
String.__name__ = true;
Array.__name__ = true;
Grammar.wc = 0;
Main.main();
})(typeof console != "undefined" ? console : {log:function(){}});
