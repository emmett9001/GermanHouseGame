package
{
    import org.flixel.*;

    public class UpstairsRoom extends MapRoom
    {
        [Embed(source="../assets/Room-3-Upper-Level.png")] private var ImgRoomUpperLevel:Class;

        override public function create():void
        {
            super.create();
            this.setupBackground(ImgRoomUpperLevel);
            this.addClickZone(new FlxPoint(20, 400), new FlxPoint(40, 40),
                null, stairsTouched);
            this.addClickZone(new FlxPoint(20, 50), new FlxPoint(40, 40),
                null, languageDoorTouched);
            this.addClickZone(new FlxPoint(400, 400), new FlxPoint(40, 40),
                null, kidsDoorTouched);

            FlxG.mouse.show();

            player = new Player(20,150);
            add(player);

            this.addClickZone(
                new FlxPoint(500,210),
                new FlxPoint(100,200),
                null,
                conversation(10,10,"Hello I am a text box!")
            );
        }

        private function stairsTouched(a:FlxSprite, b:FlxSprite):void
        {
            FlxG.switchState(new LobbyRoom());
        }

        private function kidsDoorTouched(a:FlxSprite, b:FlxSprite):void
        {
            FlxG.switchState(new KidsRoom());
        }

        private function languageDoorTouched(a:FlxSprite, b:FlxSprite):void
        {
            FlxG.switchState(new LanguageRoom());
        }
    }
}
