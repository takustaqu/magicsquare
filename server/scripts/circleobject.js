

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
	
	s.on("commands", function (data) {
		switch(data.command.toLowerCase()){
			case "open":
				openSquare(parseInt(data.player));
				break;
			case "close":
				closeSquare(parseInt(data.player));
				setHandType(parseInt(data.player),false);
				break;
			case "goo":
				setHandType(parseInt(data.player),"goo");
				break;
			case "choki":
				setHandType(parseInt(data.player),"choki");
				break;
			case "par":
				setHandType(parseInt(data.player),"par");
				break;
		}
	});

	var $squares = [$(".base.player-1 .magicsquare"),$(".base.player-2 .magicsquare")];

	function openSquare(target){
	  $squares[parseInt(target)].addClass("rotateIn").removeClass("rotateOut").removeClass("closed");
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

	
});
	