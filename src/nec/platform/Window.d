module nec.platform.Window;

import nec.core.math.Scalar;

import derelict.sdl2.sdl;
import derelict.sdl2.image;
import derelict.sdl2.mixer;
import derelict.sdl2.ttf;
import derelict.sdl2.net;

import std.stdio;
import std.string;

class Window
{
    private SDL_Window* m_window;

    this(string title,
        Pixels w,
        Pixels h,
        uint flags)
    {
        this(title, SDL_WINDOWPOS_UNDEFINED.px, SDL_WINDOWPOS_UNDEFINED.px, w, h, flags);
    }


    this(string title,
         Pixels x,
         Pixels y,
         Pixels w,
         Pixels h,
         uint flags) // Change this
    {
        DerelictSDL2.load();

//        if(SDL_Init(SDL_INIT_VIDEO) != 0)
//        {
//            writeln("SLD_Init Error");
//        }

        m_window = SDL_CreateWindow(title.toStringz(), x.toInt, y.toInt, w.toInt, h.toInt, flags);

        SDL_UpdateWindowSurface(m_window);
    }
}