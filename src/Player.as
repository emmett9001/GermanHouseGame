package{
    import org.flixel.*;

    public class Player extends FlxSprite{
        private var runSpeed:Number = 1;
        public var walkTarget:FlxPoint;

        public function Player(x:int, y:int){
            super(x, y);
            this.makeGraphic(20,20);
            walkTarget = new FlxPoint(x,y);
        }

        override public function update():void{
            super.update();
            borderCollide();

            if(FlxG.mouse.justPressed()){
                walkTarget.x = FlxG.mouse.x;
                walkTarget.y = FlxG.mouse.y;
            }

            if(this.x != walkTarget.x){
                walking();
            }

            if(this.y != walkTarget.y){
                walking();
            }
        }

        public function walking():void{
            if(this.x <= walkTarget.x){
                this.x += runSpeed;
            } else {
                this.x -= runSpeed;
            }
            if(this.y <= walkTarget.y){
                this.y += runSpeed;
            } else {
                this.y -= runSpeed;
            }
        }

        public function borderCollide():void{
            if(x >= FlxG.width - width)
                x = FlxG.width - width;
            if(this.x <= 0)
                this.x = 0;
            if(this.y >= FlxG.height - height)
                this.y = FlxG.height - height;
            if(this.y <= 0)
                this.y = 0;
        }
    }
}