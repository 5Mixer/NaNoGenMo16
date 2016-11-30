package ;

import Grammar;

enum Weather {
	Sunny;
	Warm;
	Cold;
	Rainy;
}

typedef Day = {
	var weather:Weather;
}

class Main {
	var day:Day = {
		weather : Weather.Sunny
	};

	var jobs:Array<Job> = [
		{
			name: "farmer",
			buysItems : [ "Wood", "Bread", "Pig" ],
			sellsItems : [
				{ name:"Wheat", pluralIdentifier: "some", value: 1 },
				{ name:"Pig", pluralIdentifier: "a", value: 6 }
			],
		},
		{
			name: "baker",
			buysItems : [ "Wheat" ],
			sellsItems : [
				{ name:"Bread", pluralIdentifier: "some", value: 3 }
			],
		},
		{
			name: "blacksmith",
			buysItems : [ "Steel" ],
			sellsItems : [
				{ name:"Pickaxe", pluralIdentifier: "a", value: 5},
				{ name:"Hammer", pluralIdentifier: "a", value: 5 },
			],
		},
		{
			name: "miner",
			buysItems : [ "Pickaxe" ],
			sellsItems : [
				{ name:"Steel", pluralIdentifier: "some",value: 5 },
			],
		}
	];


	var characters = [];
	var ticks = 0;

	static function main(){
		new Main();


	}

	function new(){



		Grammar.out([new BaseGrammarElement("You set up your stall and prepare to sell goods.")]);
		for (i in 0...15){
			characters.push(createCharacter());
		}


		tick();


	}


	function createCharacter (){
		var bnames  = [ "Steve", "Harry", "John", "Peter", "Joshua", "Jordan", "Daniel", "Aaron", "Adam", "Jacob", "Kevin", "Matthew", "Liam", "Alexander", "Ethan", "Blake", "Robert", "Tyler"];
		var gnames  = [ "Chloe", "Emily", "Emma", "Jennifer", "Hannah", "Amy", "Nicole", "Alice", "Ella", "Olivia", "Grace", "Megan", "Madison", "Bella", "Natalia"];

		var job = jobs[Math.floor(Math.random()*jobs.length)];
		var name = "";

		if (job.name == "baker"){
			if (Math.random() > .5){
				name = gnames[Math.floor(Math.random() * gnames.length)];
			}else{
				name = bnames[Math.floor(Math.random() * bnames.length)];
			}
		}else{
			name = bnames[Math.floor(Math.random() * bnames.length)];
		}

		return {
			name : name,
			job: job,
			inventory: [],
			money : 5 + Math.round(Math.random() * 15)
		};
	}

	function tick(){
		ticks++;

		Grammar.out([new BaseGrammarElement("<h1>Day "+ticks+"</h1>")]);

		var yesterday = day;

		if (day.weather == Weather.Sunny){
			if (Math.random() > .6) day.weather = Weather.Warm;
		}else if (day.weather == Weather.Warm){
			if (Math.random() > .6) day.weather = Weather.Sunny;
			if (Math.random() < .4) day.weather = Weather.Cold;
		}else if (day.weather == Weather.Cold){
			if (Math.random() > .6) day.weather = Weather.Warm;
			if (Math.random() < .4) day.weather = Weather.Rainy;
		}else if (day.weather == Weather.Rainy){
			if (Math.random() > .6) day.weather = Weather.Cold;
		}

		var sales = 0;
		var saleLikelyHoodMultiplier = 1.0;

		if (day.weather == Weather.Sunny){
			saleLikelyHoodMultiplier = 1.0;
		} else if (day.weather == Weather.Warm){
			saleLikelyHoodMultiplier = .8;
		} else if (day.weather == Weather.Cold){
			saleLikelyHoodMultiplier = .6;
		} else if (day.weather == Weather.Rainy){
			saleLikelyHoodMultiplier = .5;
		}

		for (character in characters){
			//character.money --;
			if (character.money < 3){
				var victim = characters[Math.floor(Math.random() * characters.length)];
				var amount:Int = Math.floor(Math.min(Math.max(0,victim.money),Math.floor(Math.random()*6)+1));
				character.money += amount;
				victim.money -= amount;
				Grammar.out([new BaseGrammarElement("With not enough coin to buy even bread, "),new CharacterElement(character),new BaseGrammarElement(" the "+character.job.name+" stole "+amount+" coins from "), new CharacterElement(victim), new BaseGrammarElement(" the "+victim.job.name+", leaving them with "+victim.money+" coins!")]);
			}
			for (character2 in characters){
				for (item in character.job.sellsItems){

					for (buys in character2.job.buysItems){
						if (buys == item.name){
							if (Math.random() > 0.4*saleLikelyHoodMultiplier) continue;
							if (item.value < character2.money){
								Grammar.out([new CharacterElement(character),
											new BaseGrammarElement(" the "+character.job.name + " sold " ),
											new ItemElement(item),
											new BaseGrammarElement(" to "),
											new CharacterElement(character2),
											new BaseGrammarElement(" the "+character2.job.name)]);

								sales++;

								character.inventory.splice(character.inventory.indexOf(item),1);
								character2.inventory.push(item);


								character2.money -= item.value;
								character.money  += item.value;
							}
						}
					}

				}
			}
		}


		Grammar.out([new BaseGrammarElement("Today was " + day.weather + ". There was "+sales+" trades.")]);
		/*if (sales < 18){
			Grammar.out("Sales were low. Perhaps the market will pick up again soon.");
		}else if (sales < 30){
			Grammar.out("Some merchants did well today, but the town was hoping for more profits");
		}else if (sales < 40){
			Grammar.out("Many townspeople are happy with the days sales. The pub is full as merchants buy their meals.");
		}else if (sales < 50){
			Grammar.out("A wonderful day at the market! The town will remember days like this.");
		}*/
		Grammar.out([new BaseGrammarElement("<br><br>")]);

		var button =  js.Browser.document.createButtonElement();
		button.textContent = "New day";
		button.onclick = function(_){
			tick();
		}
		js.Browser.document.getElementById('market').appendChild(button);

		if (ticks < tickMax)
			tick();
	}
	var tickMax = 10;
}
