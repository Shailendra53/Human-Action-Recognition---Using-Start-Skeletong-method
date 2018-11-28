function bgName = fname2bgname(fName)

switch fName
	case {'daria_bend.avi',		'daria_jack.avi',	'daria_wave1.avi',	'daria_wave2.avi'}
		bgName = 'bg_015.avi';
	case {'denis_bend.avi',		'denis_jack.avi',	'denis_pjump.avi',	'denis_wave1.avi',	'denis_wave2.avi'}
		bgName = 'bg_026.avi';
	case {'eli_bend.avi', 'eli_pjump.avi', 'eli_wave1.avi', 'eli_wave2.avi'}
		bgName = 'bg_062.avi';
	case {'ido_bend.avi', 'ido_jack.avi', 'ido_pjump.avi', 'ido_wave1.avi', 'ido_wave2.avi'}
		bgName = 'bg_062.avi';
	case {'ira_bend.avi', 'ira_jack.avi', 'ira_pjump.avi', 'ira_wave1.avi', 'ira_wave2.avi'}
		bgName = 'bg_007.avi';
	case {'lena_bend.avi', 'lena_pjump.avi', 'lena_wave1.avi', 'lena_wave2.avi', 'daria_pjump.avi'}
		bgName = 'bg_038.avi';
	case {'lyova_bend.avi', 'lyova_jack.avi', 'lyova_pjump.avi', 'lyova_wave1.avi', 'lyova_wave2.avi'}
		bgName = 'bg_046.avi';
	case {'moshe_bend.avi', 'moshe_pjump.avi', 'moshe_wave1.avi', 'moshe_wave2.avi'}
		bgName = 'bg_070.avi';
	case {'shahar_bend.avi', 'shahar_pjump.avi', 'shahar_wave1.avi', 'shahar_wave2.avi'}
		bgName = 'bg_079.avi';
    case {'moshe_jack.avi'}
        bgName = 'moshe_bg_run.avi';
	case {'shahar_jack.avi', 'eli_jack.avi'}
		bgName = 'shahar_bg_run.avi';
	case {'lena_jack.avi'}
		bgName = 'lena_bg_jack.avi';
    otherwise
		bgName = fName;
		return
end
bgName = ['backgrounds\' bgName];
return
