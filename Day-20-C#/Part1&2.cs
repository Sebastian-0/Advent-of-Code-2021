// Run with:
// docker build -t dotnet .
// docker run --rm -i dotnet

// Good resources:
// - Language reference: https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/

using System;
using System.IO;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Collections.Generic;
using static System.Console;

var algorithm = Console.ReadLine()!;

int height = 0;
int width = 0;
var lightPixels = new HashSet<(int, int)>();

int r = 0;
string? line = "";
while ((line = Console.ReadLine()) != null) {
    if (line != String.Empty) {
        width = line.Length;
        for (int c = 0; c < line.Length; c++) {
            if (line[c] == '#') {
                lightPixels.Add((c, r));
            }
        }
        r += 1;
    }
}
height = r;

int viewportX = 0;
int viewportY = 0;

WriteLine($"Lit pixels before enhancing: {lightPixels.Count}");
PrintCurrentGrid();

bool backgroundLit = false; // Background are pixels outside our current viewport
for (int i = 0; i < 2; i++) {
    Enhance();
}
WriteLine($"Lit pixels after 2 iterations: {lightPixels.Count}");

for (int i = 0; i < 48; i++) {
    Enhance();
}
WriteLine($"Lit pixels after 50 iterations: {lightPixels.Count}");

// The main idea here is that we expand the viewport by 2 pixels in each direction and
// treat everything outside as the 'background'.
void Enhance() {
    var newLightPixels = new HashSet<(int, int)>();
    for (int y = viewportY-1; y < viewportY + height+2; y++) {
        for (int x = viewportX-1; x < viewportX + width+2; x++) {
            UpdatePosition(newLightPixels, lightPixels, x, y);
        }
    }
    lightPixels = newLightPixels;
    
    // Update these after the loop so that the new pixels in the loops above are
    // treated as background when updating
    viewportX -= 1;
    viewportY -= 1;
    width += 2;
    height += 2;
    
    int bkgIdx = backgroundLit ? (1 << 9) - 1 : 0;
    backgroundLit = algorithm[bkgIdx] == '#';
}

void UpdatePosition(HashSet<(int, int)> next, HashSet<(int, int)> previous, int px, int py) {
    int idx = 0;
    for (int dy = -1; dy < 2; dy++) {
        for (int dx = -1; dx < 2; dx++) {
            idx <<= 1;
            int x = px + dx;
            int y = py + dy;
            bool isOutsideViewport = x < viewportX || y < viewportY || x >= viewportX + width || y >= viewportY + height;
            if (previous.Contains((x, y)) || isOutsideViewport && backgroundLit) {
                idx += 1;
            }
        }
    }
    if (algorithm[idx] == '#') {
        next.Add((px, py));
    }
}

void PrintCurrentGrid() {
    for (int y = viewportY; y < viewportY + height; y++) {
        for (int x = viewportX; x < viewportX + width; x++) {
            if (lightPixels.Contains((x, y))) {
                Write('#');
            } else {
                Write('.');
            }
        }
        Write('\n');
    }
}