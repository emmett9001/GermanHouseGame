package
{
    import flash.utils.Dictionary;
    import org.flixel.*;

    public class LanguageRoom extends MapRoom
    {
        [Embed(source="../assets/04-BG-01.png")] private var ImgBg:Class;
        [Embed(source="../assets/04-Kid-01.png")] private var ImgKidRight:Class;
        [Embed(source="../assets/04-Kid-02.png")] private var ImgKidLeft:Class;
        [Embed(source="../assets/04-Kid-04.png")] private var ImgKidRightEnd:Class;
        [Embed(source="../assets/04-Kid-03.png")] private var ImgKidLeftEnd:Class;
        [Embed(source="../assets/04-Parents-01.png")] private var ImgParents:Class;
        [Embed(source="../assets/04-Teacher-01.png")] private var ImgProfFront:Class;
        [Embed(source="../assets/04-Teacher-02.png")] private var ImgProfSide:Class;
        [Embed(source="../assets/04-Finger-01.png")] private var ImgProfFinger:Class;
        [Embed(source="../assets/Bubble-17.png")] private var ImgBubbleOne:Class;
        [Embed(source="../assets/Bubble-10.png")] private var ImgBubbleTwo:Class;
        [Embed(source="../assets/Bubble-02.png")] private var ImgBubbleThree:Class;
        [Embed(source="../assets/Bubble-13.png")] private var ImgBubbleFour:Class;
        [Embed(source="../assets/LeaBlock-Regular.ttf", fontFamily="LeaBlock-Regular", embedAsCFF="false")] public var FontLea:String;
        [Embed(source="../assets/man1.mp3")] private var SndMan1:Class;
        [Embed(source="../assets/man2.mp3")] private var SndMan2:Class;
        [Embed(source="../assets/dad.mp3")] private var SndDad:Class;
        [Embed(source="../assets/mom.mp3")] private var SndMom:Class;
        [Embed(source="../assets/dooropen.mp3")] private var SndDoor:Class;

        private var wordList:Array;
        private var playerQuestions:Dictionary;
        private var playerAnswers:Dictionary;
        private var boardText:FlxText;
        private var word:String;
        private var retry:Boolean = false;

        private var profTextOne:FlxText;
        private var profTextTwo:FlxText;
        private var profTextThree:FlxText;
        private var profTextFour:FlxText;
        private var profTextFive:FlxText;
        private var profTextSix:FlxText;
        private var profTextSeven:FlxText;
        private var profTextDefinition:FlxText;
        private var profTextWrong:FlxText;
        private var profTextRight:FlxText;
        private var profTextGuess:FlxText;
        private var kidTextOne:FlxText;
        private var kidTextTwo:FlxText;
        private var familyText:FlxText;

        private var profBubbleOne:FlxSprite;
        private var profBubbleTwo:FlxSprite;
        private var profFront:FlxSprite;
        private var profSide:FlxSprite;
        private var profFinger:FlxSprite;
        private var kidLeft:FlxSprite;
        private var kidRight:FlxSprite;
        private var kidBubble:FlxSprite;
        private var parents:FlxSprite;
        private var familyBubble:FlxSprite;

        private static const CHOICE_SHORT:int = 1;
        private static const CHOICE_MED:int = 2;
        private static const CHOICE_LONG:int = 3;
        private var cutChoice:Number;

        private static const SEL_PROF:String = "prof_sel";
        private static const STATE_CHOICE:int = 2;
        private static const STATE_RESULT:int = 3;

        private var lastFingerAnimationTime:Number;
        private var fingerLock:Boolean = false;
        private var fingerAnimateIndex:Number = -1;

        override public function create():void
        {
            HouseMap.getInstance().LangRoom = true;
            HouseMap.getInstance().endingCounter++;

            super.create();

            this.setupBackground(ImgBg);

            CONFIG::debugging {
                this.ending = true;
                //this.ending = this.ending;
            }

            profBubbleOne = new FlxSprite(63, 30);
            profBubbleOne.loadGraphic(ImgBubbleOne, true, true, 254, 186, true);
            profBubbleOne.alpha = 0;
            add(profBubbleOne);

            profBubbleTwo = new FlxSprite(12, 10);
            profBubbleTwo.loadGraphic(ImgBubbleTwo, true, true, 319, 389, true);
            profBubbleTwo.alpha = 0;
            add(profBubbleTwo);

            profFront = new FlxSprite(348, 49);
            profFront.loadGraphic(ImgProfFront, true, true, 271, 429, true);
            add(profFront);

            kidBubble = new FlxSprite(83, 195);
            kidBubble.loadGraphic(ImgBubbleThree, true, true, 329, 144, true);
            kidBubble.alpha = 0;
            add(kidBubble);

            profFinger = new FlxSprite(343, 69);
            profFinger.loadGraphic(ImgProfFinger, true, true, 75, 80, true);
            profFinger.addAnimation("0", [0, 1, 2, 3, 4, 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 5, 4, 3, 2, 1, 0, 8], 12, false);
            profFinger.addAnimation("1", [9, 10, 10, 11, 11, 11, 11, 12, 10, 10, 11, 11, 11, 11, 12, 9, 8], 12, false);
            profFinger.addAnimation("2", [13, 14, 15, 16, 17, 13, 14, 15, 16, 17, 13, 14, 15, 16, 17, 13, 14, 15, 16, 17, 13, 14, 15, 16, 17, 8], 12, false);
            profFinger.addAnimation("still", [8], 12);
            add(profFinger);

            profSide = new FlxSprite(490, 76);
            profSide.loadGraphic(ImgProfSide, true, true, 138, 404, true);
            profSide.alpha = 0;
            add(profSide);

            familyBubble = new FlxSprite(12, 189);
            familyBubble.loadGraphic(ImgBubbleFour, true, true, 522, 178, true);
            familyBubble.alpha = 0;
            add(familyBubble);

            if(this.ending){
                parents = new FlxSprite(-2, 311);
                parents.loadGraphic(ImgParents, true, true, 332, 166);
                add(parents);

                kidRight = new FlxSprite(337, 366);
                kidRight.loadGraphic(ImgKidRightEnd, true, true, 116, 106, true);
                kidRight.alpha = 0;
                add(kidRight);

                kidLeft = new FlxSprite(337, 370);
                kidLeft.loadGraphic(ImgKidLeftEnd, true, true, 116, 106, true);
                add(kidLeft);
            } else {
                kidRight = new FlxSprite(262, 340);
                kidRight.loadGraphic(ImgKidRight, true, true, 130, 135, true);
                add(kidRight);

                kidLeft = new FlxSprite(262, 340);
                kidLeft.loadGraphic(ImgKidLeft, true, true, 132, 136, true);
                kidLeft.alpha = 0;
                add(kidLeft);
            }

            playerQuestions = new Dictionary();
            playerAnswers = new Dictionary();

            profTextOne = new FlxText(80, 46, 200, "");
            profTextOne.setFormat("LeaBlock-Regular",18,0xff000000,"left");
            profTextOne.alpha = 0;
            add(profTextOne);

            profTextTwo = new FlxText(80, 46, 200, "");
            profTextTwo.setFormat("LeaBlock-Regular",18,0xff000000,"left");
            profTextTwo.alpha = 0;
            add(profTextTwo);

            profTextSeven = new FlxText(80, 46, 200, "");
            profTextSeven.setFormat("LeaBlock-Regular",18,0xff000000,"left");
            profTextSeven.alpha = 0;
            add(profTextSeven);

            profTextThree = new FlxText(80, 46, 200, "");
            profTextThree.setFormat("LeaBlock-Regular",18,0xff000000,"left");
            profTextThree.alpha = 0;
            add(profTextThree);

            profTextFour = new FlxText(80, 73, 200, "");
            profTextFour.setFormat("LeaBlock-Regular",18,0xff000000,"left");
            profTextFour.alpha = 0;
            add(profTextFour);

            profTextWrong = new FlxText(30, 30, 270, "");
            profTextWrong.setFormat("LeaBlock-Regular",18,0xff000000,"left");
            profTextWrong.alpha = 0;
            add(profTextWrong);

            profTextRight = new FlxText(30, 30, 270, "");
            profTextRight.setFormat("LeaBlock-Regular",18,0xff000000,"left");
            profTextRight.alpha = 0;
            add(profTextRight);

            profTextGuess = new FlxText(30, 30, 315, "");
            profTextGuess.setFormat("LeaBlock-Regular",18,0xff000000,"left");
            profTextGuess.alpha = 0;
            add(profTextGuess);

            profTextDefinition = new FlxText(30, 85, 250, "");
            profTextDefinition.setFormat("LeaBlock-Regular",18,0xff000000,"left");
            profTextDefinition.alpha = 0;
            add(profTextDefinition);

            profTextFive = new FlxText(30, 190, 250, "");
            profTextFive.setFormat("LeaBlock-Regular",18,0xff000000,"left");
            profTextFive.alpha = 0;
            add(profTextFive);

            profTextSix = new FlxText(30, 55, 260, "");
            profTextSix.setFormat("LeaBlock-Regular",18,0xff000000,"left");
            profTextSix.alpha = 0;
            add(profTextSix);

            kidTextOne = new FlxText(100, 210, 280, "");
            kidTextOne.setFormat("LeaBlock-Regular",18,0xff000000,"left");
            kidTextOne.alpha = 0;
            add(kidTextOne);

            kidTextTwo = new FlxText(100, 210, 280, "");
            kidTextTwo.setFormat("LeaBlock-Regular",18,0xff000000,"left");
            kidTextTwo.alpha = 0;
            add(kidTextTwo);

            familyText = new FlxText(35, 210, 490, "");
            familyText.setFormat("LeaBlock-Regular",18,0xff000000,"left");
            familyText.alpha = 0;
            add(familyText);

            this.switchLanguage();

            wordList = getKeys(playerQuestions);
            boardText = new FlxText(40,50,500,"");
            boardText.setFormat("LeaBlock-Regular",24,0xff000000,"center");
            boardText.alpha = 0;
            add(boardText);

            var rand:Number = Math.floor(Math.random()*wordList.length);
            word = wordList[rand].toString();
            boardText.text = word;

            conversation(new FlxPoint(100, 100), new FlxPoint(450,230),"", this, SEL_PROF,
                         playerQuestions[word], true, 40)();

            CONFIG::debugging {
                debugText = new FlxText(300,10,300,"");
                debugText.color = 0xff000000;
                debugText.size = 11;
                add(debugText);
            }

            FlxG.play(SndDoor);

            this.postCreate();
        }

        override public function switchLanguage():void
        {
            if(HouseMap.getInstance().currentLanguage == HouseMap.LANG_EN){
                if(!this.ending){
                    profTextOne.text = "Congratulations, you found the language program!";
                    profTextTwo.text = "You cannot leave the room until you have learned some German!";
                    profTextThree.text = "Let’s start!";
                    profTextFour.text = "Tell me what this word means.";
                    profTextFive.text = "You may leave and explore the other parts of Deutsches Haus now!";
                    profTextSix.text = "Now, try it again!";
                    profTextWrong.text = "That was wrong!";
                    profTextRight.text = "That was right!";
                } else if(this.ending){
                    profTextOne.text = "Congratulations, you found the language program!";
                    kidTextOne.text = "Mom! Dad! I found you!";
                    profTextTwo.text = "Your parents are trying to learn some German!";
                    profTextSeven.text = "But, I guess they need your help.";
                    kidTextTwo.text = "Really? I always thought you knew everything!";
                    profTextThree.text = "Let’s start!";
                    profTextFour.text = "Tell me what this word means.";
                    profTextFive.text = "You're a smart family after all!";
                    profTextSix.text = "Now, try it again!";
                    profTextWrong.text = "That was wrong!";
                    profTextRight.text = "That was right!";
                    familyText.text = "Thank you, teacher, we learned so much today! We'll definitely come back soon!";
                }

                playerQuestions['Wanderlust'] = new Array("One skilled in various techniques of queuing.", "Desire to wander.", "Fool’s license.");
                playerQuestions['Narrenfreiheit'] = new Array("Desire to wander.", "Supper.", "Fool’s license.");
                playerQuestions['Abendbrot'] = new Array("Fool’s license.", "Supper.", "Inner conflict.");
                playerQuestions['Zerrissenheit'] = new Array("Supper.", "Inner conflict.", "Low mountain range.");
                playerQuestions['Mittelgebirge'] = new Array("Inner conflict.", "Low mountain range.", "Roofed wicker beach chair.");
                playerQuestions['Strandkorb'] = new Array("Low mountain range.", "Roofed wicker beach chair.", "The urge to confess.");

                playerAnswers['Wanderlust'] = playerQuestions["Wanderlust"][1];
                playerAnswers['Narrenfreiheit'] = playerQuestions["Narrenfreiheit"][2];
                playerAnswers['Abendbrot'] = playerQuestions["Abendbrot"][1];
                playerAnswers['Zerrissenheit'] = playerQuestions["Zerrissenheit"][1];
                playerAnswers['Mittelgebirge'] = playerQuestions["Mittelgebirge"][1];
                playerAnswers['Strandkorb'] = playerQuestions["Strandkorb"][1];

            } else if(HouseMap.getInstance().currentLanguage == HouseMap.LANG_DE){
                if(!this.ending){
                    profTextOne.text = "Ich beglückwünsche dich, das Language Program gefunden zu haben!";
                    profTextTwo.text = "Du darfst den Raum erst wieder verlassen, wenn wir etwas englisch gelernt haben!";
                    profTextThree.text = "Los geht’s! ";
                    profTextFour.text = "Sag mir, was diese Worte heißen!";
                    profTextFive.text = "Prima, du darfst das Deutsche Haus jetzt weiter erkunden!";
                    profTextSix.text = "Versuch es gleich noch mal!";
                    profTextWrong.text = "Das war nicht richtig!";
                    profTextRight.text = "Das stimmt!";
                } else if(this.ending){
                    profTextOne.text = "Ich beglückwünsche dich, das Language Program gefunden zu haben!";
                    kidTextOne.text = "Mama und Papa, hier seid ihr!";
                    profTextTwo.text = "Deine Eltern versuchen gerade, etwas Englisch zu lernen.";
                    profTextSeven.text = "Aber sie könnten deine Hilfe gebrauchen!";
                    kidTextTwo.text = "Echt jetzt? Aber ihr wisst doch sonst immer alles!";
                    profTextThree.text = "Dann mal los!";
                    profTextFour.text = "Sag mir, was diese Worte heißen!";
                    profTextFive.text = "Ihr seid ja doch eine ganz schlaue Familie!";
                    profTextSix.text = "Versuch es gleich noch mal!";
                    profTextWrong.text = "Das war nicht richtig!";
                    profTextRight.text = "Das stimmt!";
                    familyText.text = "Danke, Herr Lehrer, wir haben heute viel gelernt! Nächstes Mal kommen wir auf jeden Fall wieder!";
                }

                playerQuestions['Earful'] = new Array("Ein leerer Papierkorb.", "Lektion oder Zurechtweisung", "Ein guter Tänzer.");
                playerQuestions['Cushy'] = new Array("Etwas Einfaches oder Bequemes.", "Eine frisch gebackene Torte.", "Die Farbe des Sonnenuntergangs.");
                playerQuestions['Wide-eyed'] = new Array("Lustvolles Gespräch.", "Treuherzig und naiv.", "Scharen von Gänsen.");
                playerQuestions['Weathervane'] = new Array("Gegenstand um die Windrichtung zu messen.", "Hängender Bildschirm.", "Angestellter bei einem Orchester.");
                playerQuestions['Facetious'] = new Array("Fließend oder weich.", "Fels in der Brandung.", "Über etwas Ernstes spaßend.");
                playerQuestions['Knee-slapper'] = new Array("Ein sehr lustiger Witz.", "Ein Schnell-Restaurant.", "Abwärtspfad.");
                playerQuestions['Canoodle'] = new Array("Umarmen und küssen.", "Immer bereit zu schlafen.", "Ein Geschenk einpacken.");

                playerAnswers['Earful'] = playerQuestions["Earful"][1];
                playerAnswers['Cushy'] = playerQuestions["Cushy"][0];
                playerAnswers['Wide-eyed'] = playerQuestions["Wide-eyed"][1];
                playerAnswers['Weathervane'] = playerQuestions["Weathervane"][0];
                playerAnswers['Facetious'] = playerQuestions["Facetious"][2];
                playerAnswers['Knee-slapper'] = playerQuestions["Knee-slapper"][0];
                playerAnswers['Canoodle'] = playerQuestions["Canoodle"][0];
            }
        }

        override public function update():void{
            super.update();

            CONFIG::debugging {
                debugText.text = "" + current_scene;
            }

            if(!this.ending){
                if (currentState == STATE_INTRO) {
                    if (current_scene == 0 && timeFrame == 1) {
                        this.incrementScene();
                        makeActive(profBubbleOne);
                    } else if (current_scene == 1 && shouldAdvanceScene(2)) {
                        makeActive(profTextOne);
                        FlxG.play(SndMan2);
                        this.incrementScene();
                    } else if (current_scene == 2 && shouldAdvanceScene(3)) {
                        makeInactive(profTextOne);
                        makeActive(profTextTwo);
                        this.incrementScene();
                    } else if (current_scene == 3 && shouldAdvanceScene(3)) {
                        makeInactive(profTextTwo);
                        makeActive(profTextThree);
                        this.incrementScene();
                    } else if (current_scene == 4 && shouldAdvanceScene(3)) {
                        makeActive(profTextFour);
                        this.incrementScene();
                    } else if (current_scene == 5 && shouldAdvanceScene(3)) {
                        switchState(STATE_CHOICE);
                        makeInactive(profBubbleTwo, profTextWrong, profTextSix);
                        makeInactive(profTextThree, profTextFour, profBubbleOne, kidRight);
                        makeInactive(profFront, profFinger);
                        makeActive(kidLeft, profSide);
                    }
                } else if (currentState == STATE_CHOICE) {
                    if (current_scene == 1 && shouldAdvanceScene(1)) {
                        makeActive(boardText);
                        this.incrementScene();
                    } else if (current_scene == 2) {
                    } else if (current_scene == 3 && shouldAdvanceScene(0)) {
                        switchState(STATE_RESULT);
                        makeInactive(boardText, profSide);
                        makeActive(profFront, profFinger, profBubbleTwo, kidLeft);
                    }
                } else if (currentState == STATE_RESULT) {
                    if (current_scene == 1 && shouldAdvanceScene(2)) {
                        FlxG.play(SndMan1);
                        if(profTextGuess.text == profTextRight.text){
                            makeActive(profTextRight);
                        } else if (profTextGuess.text == profTextWrong.text) {
                            makeActive(profTextWrong);
                        }
                        this.incrementScene();
                    } else if (current_scene == 2 && shouldAdvanceScene(2)) {
                        if(profTextGuess.text == profTextRight.text){
                            makeActive(profTextDefinition);
                        } else if (profTextGuess.text == profTextWrong.text) {
                            makeActive(profTextSix);
                        }
                        this.incrementScene();
                    } else if (current_scene == 3 && shouldAdvanceScene(2)) {
                        if(profTextGuess.text == profTextRight.text){
                            makeActive(profTextFive);
                        } else if (profTextGuess.text == profTextWrong.text) {
                            switchState(STATE_CHOICE);
                            makeInactive(profBubbleTwo, profTextWrong, profTextSix);
                            makeInactive(profTextThree, profTextFour, profBubbleOne, kidRight);
                            makeInactive(profFront, profFinger);
                            makeActive(kidLeft, profSide);
                            makeActive(boardText);
                        }
                        this.incrementScene();
                    } else if (current_scene == 4 && shouldAdvanceScene(2)){
                        this.incrementScene();
                    } else if (current_scene == 5 && shouldAdvanceScene(4)){
                        if(!retry){
                            FlxG.switchState(new UpstairsRoom());
                        }
                    }
                }

                if(currentState == STATE_INTRO){
                    if(current_scene == 1){
                    } else if(current_scene == 2){
                        fingerAnimate(current_scene);
                    } else if(current_scene == 3){
                        fingerAnimate(current_scene);
                    } else if(current_scene == 4){
                        fingerAnimate(current_scene);
                    } else if(current_scene == 5){
                        fingerAnimate(current_scene);
                    }
                } else if(currentState == STATE_CHOICE){
                    if(current_scene == 1){
                    } else if(current_scene == 2){
                        this.activeSelectorBox.incrementAlpha(ALPHA_DELTA);
                    }
                } else if(currentState == STATE_RESULT){
                    if(current_scene == 1){
                        this.activeSelectorBox.incrementAlpha(-ALPHA_DELTA);
                    } else if(current_scene == 2){
                        fingerAnimate(current_scene);
                    } else if(current_scene == 3) {
                        fingerAnimate(current_scene);
                    } else if (current_scene == 4) {
                        if(profTextGuess.text == profTextRight.text){
                            fingerAnimate(current_scene);
                        }
                    }
                }
            } else if(this.ending){
                if (currentState == STATE_INTRO) {
                    if (current_scene == 0 && timeFrame == 1) {
                        this.incrementScene();
                        makeActive(profBubbleOne);
                    } else if (current_scene == 1 && shouldAdvanceScene(2)) {
                        FlxG.play(SndMan2);
                        makeActive(profTextOne);
                        this.incrementScene();
                    } else if (current_scene == 2 && shouldAdvanceScene(3)) {
                        makeInactive(profTextOne, profBubbleOne);
                        makeActive(kidBubble, kidTextOne);
                        this.incrementScene();
                    } else if (current_scene == 3 && shouldAdvanceScene(3)) {
                        makeInactive(kidBubble, kidTextOne);
                        makeActive(profBubbleOne, profTextTwo);
                        this.incrementScene();
                    } else if (current_scene == 4 && shouldAdvanceScene(3)) {
                        makeInactive(profTextTwo);
                        makeActive(profTextSeven);
                        this.incrementScene();
                    } else if (current_scene == 5 && shouldAdvanceScene(2)) {
                        makeInactive(profTextSeven, profBubbleOne);
                        makeActive(kidBubble, kidTextTwo);
                        this.incrementScene();
                    } else if (current_scene == 6 && shouldAdvanceScene(4)) {
                        makeInactive(kidBubble, kidTextTwo);
                        makeActive(profBubbleOne, profTextThree);
                        this.incrementScene();
                    } else if (current_scene == 7 && shouldAdvanceScene(3)) {
                        makeActive(profTextFour);
                        this.incrementScene();
                    } else if (current_scene == 8 && shouldAdvanceScene(3)) {
                        switchState(STATE_CHOICE);
                        makeInactive(profBubbleTwo, profTextWrong, profTextSix);
                        makeInactive(profTextThree, profTextFour, profBubbleOne, kidLeft);
                        makeInactive(profFront, profFinger);
                        makeActive(kidRight, profSide);
                    }
                } else if (currentState == STATE_CHOICE) {
                    if (current_scene == 1 && shouldAdvanceScene(1)) {
                        makeActive(boardText);
                        this.incrementScene();
                    } else if (current_scene == 2) {
                    } else if (current_scene == 3 && shouldAdvanceScene(0)) {
                        switchState(STATE_RESULT);
                        makeInactive(boardText, profSide);
                        makeActive(profFront, profFinger, profBubbleTwo, kidRight);
                    }
                } else if (currentState == STATE_RESULT) {
                    if (current_scene == 1 && shouldAdvanceScene(1)) {
                        FlxG.play(SndMan1);
                        if(profTextGuess.text == profTextRight.text){
                            makeActive(profTextRight);
                        } else if (profTextGuess.text == profTextWrong.text) {
                            makeActive(profTextWrong);
                        }
                        this.incrementScene();
                    } else if (current_scene == 2 && shouldAdvanceScene(2)) {
                        if(profTextGuess.text == profTextRight.text){
                            makeActive(profTextDefinition);
                        } else if (profTextGuess.text == profTextWrong.text) {
                            makeActive(profTextSix);
                        }
                        this.incrementScene();
                    } else if (current_scene == 3 && shouldAdvanceScene(2)) {
                        if(profTextGuess.text == profTextRight.text){
                            makeActive(profTextFive);
                        } else if (profTextGuess.text == profTextWrong.text) {
                            switchState(STATE_CHOICE);
                            makeInactive(profBubbleTwo, profTextWrong, profTextSix);
                            makeInactive(profTextThree, profTextFour, profBubbleOne, kidLeft);
                            makeInactive(profFront, profFinger);
                            makeActive(kidRight, profSide);
                            makeActive(boardText);
                        }
                        this.incrementScene();
                    } else if (current_scene == 4 && shouldAdvanceScene(2)){
                        makeActive(familyBubble, familyText);
                        FlxG.play(SndDad);
                        FlxG.play(SndMom);
                        makeInactive(profTextRight, profTextFive, profTextDefinition, profBubbleTwo);
                        this.incrementScene();
                    } else if (current_scene == 5 && shouldAdvanceScene(2)){
                        this.incrementScene();
                    } else if (current_scene == 6 && shouldAdvanceScene(3)){
                        if(!retry){
                            this.theEnd();
                        }
                    }
                }

                if(currentState == STATE_INTRO){
                    if(current_scene == 1){
                    } else if(current_scene == 2){
                        fingerAnimate(current_scene);
                    } else if(current_scene == 3){
                    } else if(current_scene == 4){
                        fingerAnimate(current_scene);
                    } else if(current_scene == 5){
                        fingerAnimate(current_scene);
                    } else if(current_scene == 6){
                    } else if(current_scene == 7){
                        fingerAnimate(current_scene);
                    } else if(current_scene == 8){
                        fingerAnimate(current_scene);
                    }
                } else if(currentState == STATE_CHOICE){
                    if(current_scene == 1){
                    } else if(current_scene == 2){
                        this.activeSelectorBox.incrementAlpha(ALPHA_DELTA);
                    }
                } else if(currentState == STATE_RESULT){
                    if(current_scene == 1){
                        this.activeSelectorBox.incrementAlpha(-ALPHA_DELTA);
                    } else if(current_scene == 2){
                        fingerAnimate(current_scene);
                    } else if (current_scene == 3) {
                        fingerAnimate(current_scene);
                    } else if (current_scene == 4) {
                        if(profTextGuess.text == profTextRight.text){
                            fingerAnimate(current_scene);
                        }
                    } else if (current_scene == 5) {
                        fingerAnimate(current_scene);
                    }
                }
            }
        }

        private function fingerAnimate(idx:Number):void{
            if(fingerAnimateIndex != idx){
                fingerAnimateIndex = idx;
                lastFingerAnimationTime = timeFrame;
                var rand:Number = Math.floor(Math.random()*3);
                profFinger.play(rand.toString());
            }
        }

        private function doorWasClicked(a:FlxSprite, b:FlxSprite):void
        {
            FlxG.switchState(new UpstairsRoom());
        }

        override public function didSelectTextOption(idx:Number, item:FlxText,
                                                     selector:SelectorTextBox):void
        {
            if (currentState == STATE_CHOICE && current_scene == 2
                && selector._label == SEL_PROF){
                super.didSelectTextOption(idx, item, selector);

                //allow player to guess until they get the right one
                if(item.text == playerAnswers[word]){
                    profTextGuess.text = profTextRight.text;

                    if(HouseMap.getInstance().currentLanguage == HouseMap.LANG_DE){
                        profTextDefinition.text = boardText.text + " bedeutet " + "\"" + playerAnswers[word] + "\"";
                    } else if(HouseMap.getInstance().currentLanguage == HouseMap.LANG_EN) {
                        profTextDefinition.text = boardText.text + " means " + "\"" + playerAnswers[word] + "\"";
                    }
                    retry = false;
                } else {
                    profTextGuess.text = profTextWrong.text;
                    retry = true;
                }

                lastSelectionTimeFrame = timeFrame;
                incrementScene();
            }
        }
    }
}
