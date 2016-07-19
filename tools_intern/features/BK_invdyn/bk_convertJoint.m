function ret_name=bk_convertJoint(name)

switch lower(name)
       case {'root'}
       	ret_name='root';
       case {'lhipjoint'}
       	ret_name='root_@_lhipjoint';
       case {'rhipjoint'}
       	ret_name='root_@_rhipjoint';
       case {'lowerback'}
       	ret_name='root_@_lowerback';
       case {'lfemur'}
       	ret_name='lhipjoint_@_lfemur';
       case {'ltibia'}
       	ret_name='lfemur_@_ltibia';
       case {'lfoot'}
       	ret_name='ltibia_@_lfoot';
       case {'ltoes'}
       	ret_name='lfoot_@_ltoes';
       case {'rfemur'}
       	ret_name='rhipjoint_@_rfemur';
       case {'rtibia'}
       	ret_name='rfemur_@_rtibia';
       case {'rfoot'}
       	ret_name='rtibia_@_rfoot';
       case {'rtoes'}
       	ret_name='rfoot_@_rtoes';
       case {'upperback'}
       	ret_name='lowerback_@_upperback';
       case {'thorax'}
       	ret_name='upperback_@_thorax';
       case {'lowerneck'}
       	ret_name='thorax_@_lowerneck';
       case {'lclavicle'}
       	ret_name='thorax_@_lclavicle';
       case {'rclavicle'}
       	ret_name='thorax_@_rclavicle';
       case {'upperneck'}
       	ret_name='lowerneck_@_upperneck';
       case {'head'}
       	ret_name='upperneck_@_head';
       case {'lhumerus'}
       	ret_name='lclavicle_@_lhumerus';
       case {'lradius'}
       	ret_name='lhumerus_@_lradius';
       case {'lwrist'}
       	ret_name='lradius_@_lwrist';
       case {'lhand'}
       	ret_name='lwrist_@_lhand';
       case {'lthumb'}
       	ret_name='lwrist_@_lthumb';
       case {'lfingers'}
       	ret_name='lhand_@_lfingers';
       case {'rhumerus'}
       	ret_name='rclavicle_@_rhumerus';
       case {'rradius'}
       	ret_name='rhumerus_@_rradius';
       case {'rwrist'}
       	ret_name='rradius_@_rwrist';
       case {'rhand'}
       	ret_name='rwrist_@_rhand';
       case {'rthumb'}
       	ret_name='rwrist_@_rthumb';
       case {'rfingers'}
       	ret_name='rhand_@_rfingers';     
   otherwise
      ret_name=name;
end
