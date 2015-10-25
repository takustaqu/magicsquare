

$(function(){
	
	var screenName = $("body").attr("data-screen-name");

	var s = io.connect('/',{transports:[ 'websocket']});
	s.on("calibrate", function (data) {
		if(screenName != data.target){
			return false
		}else{
			setTransform($("#stage"),data.axises,true)
		}
	});

	var jankenCue = [false,false];

	var $soundBlast = $("#sound-blast");
	var $soundGuard = $("#sound-tie");

	
	s.on("commands", function (data) {
		switch(data.command.toLowerCase()){
			default:
				var player = parseInt(data.player);
			case "open":

				openSquare(parseInt(data.player));
				break;
			case "close":
				closeSquare(parseInt(data.player));
				setHandType(parseInt(data.player),false);
				break;
			case "goo":
				if(isOpened(parseInt(data.player))){
					setHandType( parseInt(data.player) ,"goo");
					jankenCue[ parseInt(data.player) ] = "goo";
					checkDuel();
				}
				break;
			case "choki":
				if(isOpened(parseInt(data.player))){
					setHandType( parseInt(data.player) ,"choki");
					jankenCue[ parseInt(data.player) ] = "choki";
					checkDuel();
				}
				break;
			case "par":
				if(isOpened(parseInt(data.player))){
					setHandType( parseInt(data.player) ,"par");
					jankenCue[ parseInt(data.player) ] = "par";
					checkDuel();
				}
				break;
		}
	});



	var $squares = [$(".base.player-1 .magicsquare"),$(".base.player-2 .magicsquare")];

	function openSquare(target){
	  $squares[parseInt(target)].addClass("rotateIn").removeClass("rotateOut").removeClass("closed");
	}

	function isOpened(target){
		return $squares[parseInt(target)].hasClass("rotateIn");
	}

	function closeSquare(target){
	  $squares[parseInt(target)].removeClass("rotateIn").addClass("rotateOut");
	}

	function setHandType(target,alias){
		if(!!alias){
			$squares[parseInt(target)].removeClass("goo choki par").addClass(alias);		
		}else{
			$squares[parseInt(target)].removeClass("goo choki par");
		}
	}

	function duel(playerA,playerB){		 
		 
		 var result = "";
		 
		if(playerA == playerB){
			return "draw"
		}else if( (playerA == "goo" && playerB=="choki") || (playerA == "choki" && playerB=="par") || (playerA == "par" && playerB=="goo")){
			return "player1";
		}else{
			return "player2";
		}
		 
	}

	function checkDuel(){

		if(!!jankenCue[0]&&!!jankenCue[1]){
			var result = duel(jankenCue[0],jankenCue[1]);
			
			console.log(jankenCue);
			if(result != "draw"){
				$soundBlast.get(0).pause();
				$soundBlast.get(0).currentTime = 0;
				$soundBlast.get(0).play();
			}else{
				$soundGuard.get(0).currentTime = 0;
				$soundGuard.get(0).play();
				
			}
			
			jankenCue = [false,false];
		}else{
			return false;
		}
	}

	
});
	