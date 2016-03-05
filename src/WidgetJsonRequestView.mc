//!
//! Copyright 2015 by Garmin Ltd. or its subsidiaries.
//! Subject to Garmin SDK License Agreement and Wearables
//! Application Developer Agreement.
//!

using Toybox.Communications as Comm;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;
using Toybox.System as Sys;

class BaseInputDelegate extends Ui.BehaviorDelegate {

    function onMenu() {
        Ui.requestUpdate();
        return true;
    }

    function initialize(handler) {
        Ui.BehaviorDelegate.initialize();
    }

    function onNextPage() {
    }
}

class WidgetJsonRequestView extends Ui.View {

    hidden var mMessage = "";

    function initialize() {
        Ui.View.initialize();
    }

    //! Load your resources here
    function onLayout(dc) {

        Comm.makeJsonRequest(
            "https://httpbin.org/get",
            {
                "Monkeys" => "Awesome",
                "ConnectIQ" => "1337"
            },
            {
                "Content-Type" => Comm.REQUEST_CONTENT_TYPE_URL_ENCODED
            },
                method(:onReceive)
            );

        onUpdate( dc );
    }

    function onReceive(responseCode, data) {
        if( responseCode == 200 ) {

            var args = data["args"];
            var keys = args.keys();

            mMessage = "";
            for( var i = 0; i < keys.size(); i++ ) {
                mMessage += Lang.format("$1$: $2$\n", [keys[i], args[keys[i]]]);
            }

        }
        else {
            mMessage = "Failed to load\nError: " + responseCode.toString();
        }
        Ui.requestUpdate();
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
        dc.setColor( Gfx.COLOR_TRANSPARENT, Gfx.COLOR_BLACK );
        dc.clear();
        dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );
        dc.drawText(25, (dc.getHeight() / 2) + 10, Gfx.FONT_SMALL, mMessage, Gfx.TEXT_JUSTIFY_LEFT);
    }
}
