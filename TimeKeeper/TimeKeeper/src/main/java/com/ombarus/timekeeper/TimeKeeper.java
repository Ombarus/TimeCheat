package com.ombarus.timekeeper;

import androidx.annotation.NonNull;

import org.godotengine.godot.Godot;
import org.godotengine.godot.plugin.GodotPlugin;

import java.util.Arrays;
import java.util.List;

public class TimeKeeper extends GodotPlugin {

    public TimeKeeper(Godot godot) {
        super(godot);
    }

    @NonNull
    @Override
    public String getPluginName() {
        return "TimeKeeper";
    }

    public String elapsedRealTime() {
        // Godot doesn't support returning long int. So convert to string.
        return Long.toString(android.os.SystemClock.elapsedRealtime());
    }

    @NonNull
    @Override
    public List<String> getPluginMethods() {
        return Arrays.asList("elapsedRealTime");
    }
}
