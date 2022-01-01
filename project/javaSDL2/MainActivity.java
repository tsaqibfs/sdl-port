/*
Simple DirectMedia Layer
Java source code (C) 2009-2014 Sergii Pylypenko

This software is provided 'as-is', without any express or implied
warranty.  In no event will the authors be held liable for any damages
arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not
   claim that you wrote the original software. If you use this software
   in a product, an acknowledgment in the product documentation would be
   appreciated but is not required. 
2. Altered source versions must be plainly marked as such, and must not be
   misrepresented as being the original software.
3. This notice may not be removed or altered from any source distribution.
*/

package net.sourceforge.clonekeenplus;

import android.app.Activity;
import java.util.ArrayList;

public class MainActivity extends org.libsdl.app.SDLActivity {
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		Globals.DataDir = this.getFilesDir().getAbsolutePath();
		Settings.LoadConfig(this); // Load Globals.DataDir from SDL 1.2 installation, we never save config file

		Log.i("SDL", "Checking for asset pack");
		try
		{
			if( android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP )
			{
				ApplicationInfo info = this.getPackageManager().getApplicationInfo(Parent.getPackageName(), 0);
				if( info.splitSourceDirs != null )
				{
					for( String apk: info.splitSourceDirs )
					{
						Log.i("SDL", "Package apk: " + apk);
						if( apk.endsWith("assetpack.apk") )
						{
							this.assetPackPath = apk;
							Log.i("SDL", "Found asset pack: " + this.assetPackPath);
						}
					}
				}
			}
		}
		catch( Exception eee )
		{
			Log.i("SDL", "Asset pack exception: " + eee);
		}

		Settings.setEnvVars(this);
	}

	@Override
	protected String[] getLibraries() {
		ArrayList<String> ret = new ArrayList<String>();
		for (String l: Globals.AppLibraries) {
			ret.add(GetMappedLibraryName(l));
		}
		return ret.toArray(new String[0]);
	}

	@Override
	protected String[] getArguments() {
		return new String[0];
	}

	private static String GetMappedLibraryName(final String s) {
		for (int i = 0; i < Globals.LibraryNamesMap.length; i++) {
			if (Globals.LibraryNamesMap[i][0].equals(s))
				return Globals.LibraryNamesMap[i][1];
		}
		return s;
	}

	public String ObbMountPath = null; // Deprecated, always empty
	public String assetPackPath = null; // Not saved to the config file
}
