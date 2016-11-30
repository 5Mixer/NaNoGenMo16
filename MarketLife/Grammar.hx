package;

#if js
import js.Browser;
#end

interface GrammarElement {
	public function text ():String;
	public function hover ():String;
}
class BaseGrammarElement implements GrammarElement {
	public var textElement:String;
	var hoverElement:String;
	public function new (text,?hoverText){
		this.textElement = text;
		this.hoverElement = hoverText;
	}
	public function text ():String{
		return textElement;
	}
	public function hover ():String{
		return hoverElement;
	}
}
class CharacterElement implements GrammarElement {
	var char:Character;

	public function new (character){
		this.char = character;
	}
	public function text ():String{
		return "<b>"+this.char.name+"</b>";
	}
	public function hover ():String{
		return "
			Name: "+char.name+". <br>
			Profession: "+char.job.name+". <br>
			Money: $"+char.money+"<br>
			Buys: "+listArrayOfStrings(char.job.buysItems)+". <br>
			Sells: "+printItems(char.job.sellsItems)+".
			Inventory: "+printItems(char.inventory)+ "<br>
		";
	}

	function listArrayOfStrings(array:Array<String>){
		var a = "";
		for (i in array){
			a += i +", ";
		}
		return a;
	}
	function printItems (inv:Array<Item>){
		var a = "";

		for (item in inv){
			a += item.pluralIdentifier + " " + item.name+ ", ";
		}

		return a;
	}
}

class ItemElement implements GrammarElement {
	var item:Item;

	public function new (item){
		this.item = item;
	}
	public function text ():String{
		return "<b>"+this.item.pluralIdentifier+" "+this.item.name+"</b>";
	}
	public function hover ():String{
		return "
			value: $"+this.item.value+"
		";
	}
}

class Grammar {
	public static var wc = 0;
	public static function out (what:Array<GrammarElement>){
		#if !js
		trace(what);
		#else
		for (element in what){

			if (element.hover() != null && element.hover() != ""){
				Browser.document.getElementById('market').innerHTML +=
				"<span class='tooltipProvider'>
					"+element.text()+"
					<span class='tooltip'>
						"+element.hover()+"

					</span>
				</span>";
			}else{
				Browser.document.getElementById('market').innerHTML += element.text();
			}
			Grammar.wc += element.text().split(" ").length;
			//Browser.document.getElementById('market').innerHTML += Grammar.wc;
		}
		Browser.document.getElementById('market').innerHTML += '<br/>';
		#end
	}
}
