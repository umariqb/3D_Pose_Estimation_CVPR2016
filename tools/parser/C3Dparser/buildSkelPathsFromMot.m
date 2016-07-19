function paths = buildSkelPathsFromMot( mot )

paths = { (getLabelIndex(mot.nameMap, {'root', 'lhip', 'lknee', 'lankle', 'ltoes'}))';...                           % left leg
          (getLabelIndex(mot.nameMap, {'root', 'rhip', 'rknee', 'rankle', 'rtoes'}))'; ...                          % right leg
          (getLabelIndex(mot.nameMap, {'root', 'belly', 'chest', 'neck', 'head', 'headtop' }))'; ...                % spine and head
          (getLabelIndex(mot.nameMap, {'neck', 'lclavicle', 'lshoulder', 'lelbow', 'lwrist', 'lfingers'}))'; ...    % left arm
          (getLabelIndex(mot.nameMap, {'neck', 'rclavicle', 'rshoulder', 'relbow', 'rwrist', 'rfingers'}))' ...     % right arm
};
