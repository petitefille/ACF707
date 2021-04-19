copyfile(fullfile(docroot, 'techdoc', 'creating_guis',...
    'examples','simple_gui*.*')),fileattrib('simple_gui*.*','+w');
guide simple_gui.fig;
edit simple_gui.m