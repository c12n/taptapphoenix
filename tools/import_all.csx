using System;
using System.IO;
using UndertaleModLib.Util;
using ImageMagick;

// Combined asset patch for the c12n rebuild:
//  1. spr_Credits — original art extended downward with the c12n line
//  2. Accessibility pack — high-contrast note orbs and darkened gameplay
//     backgrounds (same sizes/frames, art otherwise untouched)
// Paths use __WORKSPACE__ so CI can point them at the checkout; locally
// they are sed-replaced with the project directory before running.

EnsureDataLoaded();

void ImportFrame(string spriteName, int frame, string pngPath)
{
    var spr = Data.Sprites.ByName(spriteName);
    if (spr == null) throw new Exception(spriteName + " not found");
    MagickImage img = TextureWorker.ReadBGRAImageFromFile(pngPath);
    ushort w = (ushort)img.Width;
    ushort h = (ushort)img.Height;
    if (w != spr.Width || h != spr.Height)
        throw new Exception(spriteName + " frame " + frame + ": size mismatch " + w + "x" + h + " vs sprite " + spr.Width + "x" + spr.Height);

    int lastPage = Data.EmbeddedTextures.Count - 1;
    int lastItem = Data.TexturePageItems.Count - 1;

    UndertaleEmbeddedTexture texture = new();
    texture.Name = new UndertaleString($"Texture {++lastPage}");
    texture.TextureData.Image = GMImage.FromMagickImage(img).ConvertToPng();
    Data.EmbeddedTextures.Add(texture);

    UndertaleTexturePageItem item = new();
    item.Name = new UndertaleString($"PageItem {++lastItem}");
    item.SourceX = 0;
    item.SourceY = 0;
    item.SourceWidth = w;
    item.SourceHeight = h;
    item.TargetX = 0;
    item.TargetY = 0;
    item.TargetWidth = w;
    item.TargetHeight = h;
    item.BoundingWidth = w;
    item.BoundingHeight = h;
    item.TexturePage = texture;
    Data.TexturePageItems.Add(item);

    spr.Textures[frame].Texture = item;
    ScriptMessage("imported " + spriteName + " frame " + frame);
}

// --- 1. Credits (size changes 500x700 -> 500x788, mask handled specially) ---
{
    var spr = Data.Sprites.ByName("spr_Credits");
    if (spr == null) throw new Exception("spr_Credits not found");
    MagickImage img = TextureWorker.ReadBGRAImageFromFile("__WORKSPACE__/tools/spr_Credits_new.png");
    ushort w = (ushort)img.Width;
    ushort h = (ushort)img.Height;

    int lastPage = Data.EmbeddedTextures.Count - 1;
    int lastItem = Data.TexturePageItems.Count - 1;

    UndertaleEmbeddedTexture texture = new();
    texture.Name = new UndertaleString($"Texture {++lastPage}");
    texture.TextureData.Image = GMImage.FromMagickImage(img).ConvertToPng();
    Data.EmbeddedTextures.Add(texture);

    UndertaleTexturePageItem item = new();
    item.Name = new UndertaleString($"PageItem {++lastItem}");
    item.SourceX = 0;
    item.SourceY = 0;
    item.SourceWidth = w;
    item.SourceHeight = h;
    item.TargetX = 0;
    item.TargetY = 0;
    item.TargetWidth = w;
    item.TargetHeight = h;
    item.BoundingWidth = w;
    item.BoundingHeight = h;
    item.TexturePage = texture;
    Data.TexturePageItems.Add(item);

    spr.Textures[0].Texture = item;
    uint oldH = spr.Height;
    spr.Width = (uint)w;
    spr.Height = (uint)h;

    if (spr.CollisionMasks.Count > 0)
    {
        var mask = spr.CollisionMasks[0];
        int rowBytes = (int)Math.Ceiling(w / 8.0);
        byte[] oldData = mask.Data;
        int oldRowBytes = (int)Math.Ceiling(mask.Width / 8.0);
        byte[] newData = new byte[rowBytes * h];
        for (int y = 0; y < h; y++)
        {
            int srcY = Math.Min(y, mask.Height - 1);
            Array.Copy(oldData, srcY * oldRowBytes, newData, y * rowBytes, Math.Min(oldRowBytes, rowBytes));
        }
        mask.Width = w;
        mask.Height = h;
        mask.Data = newData;
        if (spr.MarginBottom == (int)oldH - 1)
            spr.MarginBottom = (int)h - 1;
    }
    ScriptMessage("spr_Credits now " + spr.Width + "x" + spr.Height);
}

// --- 2. Accessibility pack: high-contrast orbs + darkened backgrounds ---
for (int i = 0; i < 4; i++)
{
    ImportFrame("spr_ballTapTap", i, "__WORKSPACE__/tools/hc/spr_ballTapTap_" + i + ".png");
    ImportFrame("spr_ball", i, "__WORKSPACE__/tools/hc/spr_ball_" + i + ".png");
}
ImportFrame("bg_main_new", 0, "__WORKSPACE__/tools/hc/bg_main_new_0.png");
ImportFrame("bg_main_full", 0, "__WORKSPACE__/tools/hc/bg_main_full_0.png");
ImportFrame("bg_overdrive_new", 0, "__WORKSPACE__/tools/hc/bg_overdrive_new_0.png");
ImportFrame("bg_overdrive_full", 0, "__WORKSPACE__/tools/hc/bg_overdrive_full_0.png");

ScriptMessage("import_all done");
