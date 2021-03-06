package{
    import org.flixel.*;

    public class TextBox extends FlxText{
        [Embed(source="../assets/LeaBlock-Regular.ttf", fontFamily="LeaBlock-Regular", embedAsCFF="false")] public var FontLea:String;

        public var box:FlxSprite;
        public var boxWidth:Number = 300;
        public var boxHeight:Number = 100;
        public var destination:FlxPoint;
        public var boxPoint:FlxPoint;
        public var debugText:FlxText;
        public var _text:String;
        public var _size:FlxPoint;
        public var _origin:FlxPoint;

        public function TextBox(origin:FlxPoint, size:FlxPoint, _text:String, alignment:String="left"){
            boxPoint = new FlxPoint(origin.x, origin.y);

            this._text = _text;
            this._origin = origin;
            this._size = size;

            box = new FlxSprite(origin.x, origin.y);
            box.makeGraphic(size.x, size.y, 0x77BAF0FF);
            box.immovable = true;
            CONFIG::debugging {
                FlxG.state.add(box);
            }

            super(origin.x, origin.y, size.x, _text);
            this.setFormat("LeaBlock-Regular",18,0xff000000,alignment);

            debugText = new FlxText(10,10,100,"move damn it");
            debugText.color = 0xff000000;
        }
    }
}
