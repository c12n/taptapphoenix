using System;
using System.IO;
using UndertaleModLib.Util;
using ImageMagick;

EnsureDataLoaded();

string pngPath = "__WORKSPACE__/tools/spr_Credits_new.png";

var spr = Data.Sprites.ByName("spr_Credits");
if (spr == null) throw new Exception("spr_Credits not found");

MagickImage img = TextureWorker.ReadBGRAImageFromFile(pngPath);
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

// Collision mask must match the new size (1 bit per pixel, rows padded
// to whole bytes: ceil(500/8)=63 bytes/row). The credits object has no
// collision/mouse events, so extending the last row downward is safe.
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
// Origin intentionally unchanged (250, 350): panel top stays anchored,
// the new band grows downward from the original bottom edge.
ScriptMessage("spr_Credits now " + spr.Width + "x" + spr.Height + " origin=" + spr.OriginX + "," + spr.OriginY);
