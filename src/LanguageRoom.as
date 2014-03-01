package
{
    import flash.utils.Dictionary;
    import org.flixel.*;

    public class LanguageRoom extends MapRoom
    {
        [Embed(source="../assets/04-BG-01.png")] private var ImgBg:Class;
        [Embed(source="../assets/04-Kid-01.png")] private var ImgKidRight:Class;
        [Embed(source="../assets/04-Kid-02.png")] private var ImgKidLeft:Class;
        [Embed(source="../assets/04-Teacher-01.png")] private var ImgProfFront:Class;
        [Embed(source="../assets/04-Teacher-02.png")] private var ImgProfSide:Class;
        [Embed(source="../assets/Bubble-09.png")] private var ImgBubbleOne:Class;
        [Embed(source="../assets/Bubble-10.png")] private var ImgBubbleTwo:Class;
        [Embed(source="../assets/LeaBlock-Regular.ttf", fontFamily="LeaBlock-Regular", embedAsCFF="false")] public var FontLea:String;
        private static const SEL_PROF:String = "prof_sel";
        private var wordList:Array;
        private var playerQuestions:Dictionary;
        private var playerAnswers:Dictionary;
        private var boardText:FlxText;
        private var word:String;

        private var profBubbleOne:FlxSprite;
        private var profBubbleTwo:FlxSprite;
        private var profFront:FlxSprite;
        private var profSide:FlxSprite;
        private var kidLeft:FlxSprite;
        private var kidRight:FlxSprite;

        private static const CHOICE_SHORT:int = 1;
        private static const CHOICE_MED:int = 2;
        private static const CHOICE_LONG:int = 3;
        private var cutChoice:Number;

        private static const STATE_INTRO:int = 1;
        private static const STATE_CHOICE:int = 2;
        private static const STATE_RESULT:int = 3;
        private var currentState:int = STATE_INTRO;
        public var current_scene:Number = 0;

        private const ALPHA_DELTA:Number = .04;

        //german player version
        //Earful - (1) An empty waste basket. (2) A lot of angry talk. (3) A good dancer.
        //Cushy - (1) Something easy or comfortable. (2) A freshly baked pie. (3) The color of a sunset.
        //Wide-eyed - (1) A juicy conversation. (2) Being unsophisticated or innocent. (3) Large flocks of geese.
        //Weathervane - (1) Used to measure wind direction. (2) A mountable screen. (3) A recruiter for an orchestra.
        //Facetious - (1) Soft, swishy or sweeping. (2) Supportive or like a boulder. (3) Joking about serious issues.
        //Knee-slapper (1) A very funny joke. (2) A fast-food restaurant. (3) A very slippery slope.
        //Canoodle (1) Hugging and kissing. (2) Getting ready for bed. (3) Wrapping a present.

        override public function create():void
        {
            HouseMap.getInstance().LangRoom = true;
            HouseMap.getInstance().endingCounter++;

            super.create();

            if(HouseMap.getInstance().currentLanguage == HouseMap.LANG_EN){
                //eng stuff
            } else if(HouseMap.getInstance().currentLanguage == HouseMap.LANG_DE){
                playerQuestions = new Dictionary();
                playerQuestions['Earful'] = new Array("An empty waste basket.", "A lot of angry talk.", "A good dancer.");
                playerQuestions['Cushy'] = new Array("Something easy or comfortable.", "A freshly baked pie.", "The color of a sunset.");
                playerQuestions['Wide-eyed'] = new Array("A juicy conversation.", "Being unsophisticated or innocent.", "Large flocks of geese.");
                playerQuestions['Weathervane'] = new Array("Used to measure wind direction.", "A mountable screen.", "A recruiter for an orchestra.");
                playerQuestions['Facetious'] = new Array("Soft, swishy or sweeping.", "Supportive or like a boulder.", "Joking about serious issues.");
                playerQuestions['Knee-slapper'] = new Array("A very funny joke.", "A fast-food restaurant.", "A very slippery slope.");
                playerQuestions['Canoodle'] = new Array("Hugging and kissing.", "Getting ready for bed.", "Wrapping a present.");

                playerAnswers = new Dictionary();
                playerAnswers['Earful'] = new String("A lot of angry talk.");
                playerAnswers['Cushy'] = new String("Something easy or comfortable.");
                playerAnswers['Wide-eyed'] = new String("Being unsophisticated or innocent.");
                playerAnswers['Weathervane'] = new String("Used to measure wind direction.");
                playerAnswers['Facetious'] = new String("Joking about serious issues.");
                playerAnswers['Knee-slapper'] = new String("A very funny joke.");
                playerAnswers['Canoodle'] = new Array("Hugging and kissing.");
            }

            wordList = getKeys(playerQuestions);
            boardText = new FlxText(230,100,500,"");
            boardText.setFormat("LeaBlock-Regular",18,0xff000000,"center");

            debugText = new FlxText(10,10,100,"");
            debugText.color = 0xff000000;
            debugText.size = 18;

            if(this.ending){
                this.setupBackground(ImgBg);
                //this.addClickZone(new FlxPoint(100, 100), new FlxPoint(40, 40),
                //    null, doorWasClicked);

                add(debugText);
                add(boardText);

                var randend:Number = Math.floor(Math.random()*wordList.length);
                word = wordList[randend].toString();
                boardText.text = word;
                conversation(new FlxPoint(profBubbleOne.x, profBubbleOne.y), new FlxPoint(600,600),"", this, SEL_PROF,
                         playerQuestions[word])();
            } else {
                this.setupBackground(ImgBg);
                //this.addClickZone(new FlxPoint(100, 100), new FlxPoint(40, 40),
                //    null, doorWasClicked);

                profFront = new FlxSprite(343, 49);
                profFront.loadGraphic(ImgProfFront, true, true, 271, 429, true);
                add(profFront);

                profSide = new FlxSprite(490, 76);
                profSide.loadGraphic(ImgProfSide, true, true, 138, 404, true);
                add(profSide);

                kidRight = new FlxSprite(262, 340);
                kidRight.loadGraphic(ImgKidRight, true, true, 130, 135, true);
                add(kidRight);

                kidLeft = new FlxSprite(262, 340);
                kidLeft.loadGraphic(ImgKidLeft, true, true, 132, 136, true);
                add(kidLeft);

                profBubbleOne = new FlxSprite(63, 30);
                profBubbleOne.loadGraphic(ImgBubbleOne, true, true, 254, 137, true);
                add(profBubbleOne);

                profBubbleTwo = new FlxSprite(12, 10);
                profBubbleTwo.loadGraphic(ImgBubbleTwo, true, true, 319, 389, true);
                add(profBubbleTwo);

                add(debugText);
                add(boardText);

                var rand:Number = Math.floor(Math.random()*wordList.length);
                word = wordList[rand].toString();
                boardText.text = word;
                conversation(new FlxPoint(profBubbleOne.x, profBubbleOne.y), new FlxPoint(600,600),"", this, SEL_PROF,
                         playerQuestions[word])();
            }
        }

        override public function update():void{
            super.update();
        }

        private function doorWasClicked(a:FlxSprite, b:FlxSprite):void
        {
            FlxG.switchState(new UpstairsRoom());
        }

        override public function didSelectTextOption(idx:Number, item:FlxText,
                                                     selector:SelectorTextBox):void
        {
            if (this.ending && selector._label == SEL_PROF) {
                if(item.text == playerAnswers[word]){
                    debugText.text = "win";
                } else {
                    debugText.text = "lose";
                }
                //add timer for this? bc someone will probs say something
                //depending on whether you win or lose
                //selector.destroy();
                //FlxG.switchState(new MenuState());
            } else if(!this.ending && selector._label == SEL_PROF){
                if(item.text == playerAnswers[word]){
                    debugText.text = "win";
                } else {
                    debugText.text = "lose";
                }
            }
        }
    }
}
