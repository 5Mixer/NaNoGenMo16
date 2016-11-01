package ;

enum Weather {
	Sunny;
	Warm;
	Cold;
	Rainy;
}

typedef Day = {
	var weather:Weather;
}

typedef Item = {
	var name:String;
	var number:Int;
	var value:Int;
}

typedef Job = {
	var name:String;
	var buysItems:Array<String>;
	var sellsItems:Array<Item>;
}

typedef Character = {
	var job : Job;
	var name : String;
	var money : Int;
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
				{ name:"Wheat", number:null, value: 1 },
				{ name:"Pig", number:1, value: 6 }
			],
		},
		{
			name: "baker",
			buysItems : [ "Wheat" ],
			sellsItems : [
				{ name:"Bread", number:1, value: 3 }
			],
		},
		{
			name: "blacksmith",
			buysItems : [ "Steel" ],
			sellsItems : [
				{ name:"Pickaxe", number:1, value: 5 },
				{ name:"Hammer", number:1, value: 5 },
			],
		},
		{
			name: "miner",
			buysItems : [ "Pickaxe" ],
			sellsItems : [
				{ name:"Steel", number:1, value: 5 },
			],
		}
	];


	var characters = [];
	var ticks = 0;

	static function main(){
		new Main();
	}

	function new(){
		trace("You set up your stall and prepare to sell goods.");
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
			money : 5 + Math.round(Math.random() * 15)
		};
	}

	function tick(){
		ticks++;

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
			if (character.money < 1){
				var victim = characters[Math.floor(Math.random() * characters.length)];
				var amount:Int = Math.floor(Math.min(Math.max(0,victim.money),Math.floor(Math.random()*6)+1));
				character.money += amount;
				victim.money -= amount;
				trace("Without a single coin, "+character.name+" the "+character.job.name+" stole "+amount+" coins from " + victim.name + " the "+victim.job.name+", leaving them with "+victim.money+" coins!");
			}
			for (character2 in characters){
				for (item in character.job.sellsItems){

					for (buys in character2.job.buysItems){
						if (buys == item.name){
							if (Math.random() > 0.9*saleLikelyHoodMultiplier) continue;
							if (item.value < character2.money){
								trace(character.name+" the "+character.job.name + " sold " + item.name + " to " + character2.name+" the "+character2.job.name);

								sales++;

								character2.money -= item.value;
								character.money  += item.value;
							}
						}
					}

				}
			}
		}


		trace("Today was " + day.weather + ". There was "+sales+" trades.");

		Sys.sleep(.1);

		if (ticks < 100)
			tick();
	}
}
