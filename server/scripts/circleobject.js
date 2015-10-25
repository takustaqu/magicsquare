

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
	var $soundOpen= $("#sound-open");
	var $soundClose = $("#sound-close");

	var queing = false;
	s.on("commands", function (data) {
		if(queing) return false;
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
	  $soundOpen.get(0).pause();
	$soundOpen.get(0).currentTime = 0;
	$soundOpen.get(0).play();
	}

	function isOpened(target){
		return $squares[parseInt(target)].hasClass("rotateIn");
	}

	function closeSquare(target){
	  $squares[parseInt(target)].removeClass("rotateIn").addClass("rotateOut");
	  $soundClose.get(0).pause();
	$soundClose.get(0).currentTime = 0;
	$soundClose.get(0).play();
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
			var queing = true;
			var result = duel(jankenCue[0],jankenCue[1]);
			
			console.log(jankenCue);
			if(result != "draw"){
				$soundBlast.get(0).pause();
				$soundBlast.get(0).currentTime = 0;
				$soundBlast.get(0).play();
				
				if(result == "player1"){
					$(".score .player-1 .win .num").text(parseInt($(".score .player-1 .win .num").text())+1);
					$(".score .player-2 .lose .num").text(parseInt($(".score .player-2 .lose .num").text())+1);
				}

				if(result == "player2"){
					$(".score .player-2 .win .num").text(parseInt($(".score .player-2 .win .num").text())+1);
					$(".score .player-1 .lose .num").text(parseInt($(".score .player-1 .lose .num").text())+1);
				}

				
			}else{
				$soundGuard.get(0).pause();
				$soundGuard.get(0).currentTime = 0;
				$soundGuard.get(0).play();
				
			}
			setTimeout(function(){
				$(".base .magicsquare .overlay").animate({"opacity":0},"slow",function(){
					setHandType(0,false);
					setHandType(1,false);
					$(this).css({"opacity":1});
					queing = false;
				})
			},1500)
			
			jankenCue = [false,false];
		}else{
			return false;
		}
	}

	
});
	