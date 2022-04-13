/*
 * Copyright 2022 Lains
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

namespace Countdown {
	[GtkTemplate (ui = "/io/github/lainsce/Countdown/mainwindow.ui")]
	public class MainWindow : Adw.ApplicationWindow {
	    [GtkChild]
	    unowned Gtk.MenuButton menu_button;

	    public EventViewModel view_model { get; construct; }

	    public SimpleActionGroup actions { get; construct; }
        public const string ACTION_PREFIX = "win.";
        public const string ACTION_ABOUT = "action_about";
        public const string ACTION_KEYS = "action_keys";
        public const string ACTION_NEW_EVENT = "action_new_event";
        public static Gee.MultiMap<string, string> action_accelerators = new Gee.HashMultiMap<string, string> ();
        private const GLib.ActionEntry[] ACTION_ENTRIES = {
              {ACTION_ABOUT, action_about},
              {ACTION_KEYS, action_keys},
              {ACTION_NEW_EVENT, action_new_event},
        };

        public Adw.Application app { get; construct; }
		public MainWindow (Adw.Application app, EventViewModel view_model) {
			Object (
			    application: app,
			    view_model: view_model,
			    app: app
			);
		}

		static construct {
		}

        construct {
            actions = new SimpleActionGroup ();
            actions.add_action_entries (ACTION_ENTRIES, this);
            insert_action_group ("win", actions);

            foreach (var action in action_accelerators.get_keys ()) {
                var accels_array = action_accelerators[action].to_array ();
                accels_array += null;

                app.set_accels_for_action (ACTION_PREFIX + action, accels_array);
            }
            app.set_accels_for_action("app.quit", {"<Ctrl>q"});
            app.set_accels_for_action("win.action_keys", {"<Ctrl>question"});
            app.set_accels_for_action("win.action_new_event", {"<Ctrl>n"});

            weak Gtk.IconTheme default_theme = Gtk.IconTheme.get_for_display (Gdk.Display.get_default ());
            default_theme.add_resource_path ("/io/github/lainsce/Countdown");

            var builder = new Gtk.Builder.from_resource ("/io/github/lainsce/Countdown/menu.ui");
            menu_button.menu_model = (MenuModel)builder.get_object ("menu");

            if (Config.DEVELOPMENT) {
                add_css_class ("devel");
            }

            this.set_size_request (360, 100);
			this.show ();
		}

		// IO?
        [GtkCallback]
        void on_new_event_requested () {
            view_model.create_new_event (null);
        }

        [GtkCallback]
        public void on_event_update_requested (Event event) {
            view_model.update_event (event);
        }

        public void action_new_event () {
            var new_event_dialog = new Widgets.Dialog (view_model);
            new_event_dialog.set_transient_for (this);
            new_event_dialog.show ();
        }

        public void action_keys () {
            try {
                var build = new Gtk.Builder ();
                build.add_from_resource ("/io/github/lainsce/Countdown/keys.ui");
                var window =  (Gtk.ShortcutsWindow) build.get_object ("shortcuts-countdown");
                window.set_transient_for (this);
                window.show ();
            } catch (Error e) {
                warning ("Failed to open shortcuts window: %s\n", e.message);
            }
        }

        public void action_about () {
            const string COPYRIGHT = "Copyright \xc2\xa9 2022 Paulo \"Lains\" Galardi\n";

            const string? AUTHORS[] = {
                "Paulo \"Lains\" Galardi",
                null
            };

            var program_name = "Countdown" + Config.NAME_SUFFIX;
            Gtk.show_about_dialog (this,
                                   "program-name", program_name,
                                   "logo-icon-name", Config.APP_ID,
                                   "version", Config.VERSION,
                                   "comments", _("Track events until they happen or since they happened."),
                                   "copyright", COPYRIGHT,
                                   "authors", AUTHORS,
                                   "artists", null,
                                   "license-type", Gtk.License.GPL_3_0,
                                   "wrap-license", false,
                                   // TRANSLATORS: 'Name <email@domain.com>' or 'Name https://website.example'
                                   "translator-credits", _("translator-credits"),
                                   null);
        }
	}
}
