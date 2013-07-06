package flambe.display.tileSheet;


import flambe.Component;

import haxe.Json;
import flambe.display.tileSheet.Format ;

class TileSheetHelper extends Component {


    public function new():Void {


    }

    public function prepareAnimTexture(data:String):AnimTextureSheet {
        var seqRaw:Dynamic = Json.parse(data);

        var animData:Array<FrameData> = new Array<FrameData>();
        populateFrameArray(animData, seqRaw.frames);


        animData.sort(onShort) ;
        var tileSheet:AnimTextureSheet = new AnimTextureSheet();
        tileSheet.init(animData);
        return tileSheet;
    }


    public function prepareShoesAnimTexture(data:String):AnimTextureSheet {


        var animData:Array<FrameData> = new Array<FrameData>();

        var xml = Xml.parse(data);
        var fast = new haxe.xml.Fast(xml.firstElement());


//SubTexture

        var phone = fast.nodes.SubTexture;


        for (p in phone) {

            animData.push({ x:Std.parseFloat(p.att.x), y: Std.parseFloat(p.att.y), w:Std.parseFloat(p.att.width), h: Std.parseFloat(p.att.height), offX:0, offY:0, id:p.att.name.substring(0, p.att.name.lastIndexOf(".png"))});//
        }


        var tileSheet:AnimTextureSheet = new AnimTextureSheet();
        tileSheet.init(animData);
        return tileSheet;
    }

    function onShort(ad:FrameData, bd:FrameData):Int {
        var a:String = ad.id.toLowerCase();
        var b:String = bd.id.toLowerCase();

        if (a < b) return -1;
        if (a > b) return 1;
        return 0;

    }

    function populateFrameArray(arDest:Array<FrameData>, src:Dynamic):Void {
        var entry:SheetFormat;
        var nameId:String;
        var item:FrameData;
        for (keyName in Reflect.fields(src)) {
            nameId = keyName.substring(0, keyName.lastIndexOf(".png"));
            entry = Reflect.field(src, keyName);
            item = entry.frame;
            item.id = nameId;
            item.offX = 0;
            item.offY = 0;
            if (entry.trimmed) {
                item.offX = entry.spriteSourceSize.x;
                item.offY = entry.spriteSourceSize.y;
            }
            arDest.push(item);
        }

    }


}

