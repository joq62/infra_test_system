%% This is the application resource file (.app file) for the 'base'
%% application.
{application, ta,
[{description, "test agent" },
{vsn, "1.0.0" },
{modules, 
	  [ta_app,ta_sup,ta]},
{registered,[ta]},
{applications, [kernel,stdlib]},
{mod, {ta_app,[]}},
{start_phases, []}
]}.
