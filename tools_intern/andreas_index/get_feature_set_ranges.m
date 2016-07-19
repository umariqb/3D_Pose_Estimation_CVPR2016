function ranges=get_feature_set_ranges(feature_set, flag)

length_lower = 12;
length_upper = 14;
length_mix = 13;
length_mix_avr = 14;
length_bodo_lower = 14;
length_fullBodyRelationalReal = 12;
length_fullBodyRelationalBool = 12;
length_fullBodyAngularReal = 12;



if (nargin < 2)
    flag = false;
end

if (~iscell(feature_set))
    feature_set = {feature_set};
end

len = size(feature_set, 2);
ranges = cell(1,len);

for k = 1:len
    current_set = feature_set{k};
    current_set_name = concatStringsInCell(current_set);

    switch current_set_name
        case 'AK_lower'
            ranges{k} = [1:length_lower];
            if (flag && (k > 1))
               ranges{k} = (ranges{k-1}(end)) + (1:length_lower);
            else
                ranges{k} = [1:length_lower];
            end
        case 'AK_upper'
            if (flag && (k > 1))
                    ranges{k} = ranges{k-1}(end) + (1:length_upper);
            else
                ranges{k} = [1:length_upper];
            end

        case 'AK_mix'
            if (flag && (k > 1))
                    ranges{k} = ranges{k-1}(end) + (1:length_mix);
            else
                ranges{k} = [1:length_mix];
            end
        case 'AK_mix_avr'
            if (flag && (k > 1))
                    ranges{k} = ranges{k-1}(end) + (1:length_mix_avr);
            else
                ranges{k} = [1:length_mix_avr];
            end
        case 'BODO_lower'
            if (flag && (k > 1))
                    ranges{k} = ranges{k-1}(end) + (1:length_bodo_lower);
            else
                ranges{k} = [1:length_bodo_lower];
            end

        case 'AK_lower_AK_mix'
            ranges{k} = [1:length_lower+length_mix];
        case 'AK_lower_AK_upper'
            ranges{k} = [1:length_lower+length_upper];
        case 'AK_upper_AK_mix'
            ranges{k} = [1:length_upper+length_mix];
        case 'AK_lower_AK_upper_AK_mix'
            ranges{k} = [1:length_lower+length_upper+length_mix];
        case 'BK_kinEnergy'
            ranges{k} = [1:11];
        case 'BK_kinEnergy2'
            ranges{k} = [1:12];
        case 'AK_lower_crippled'
            ranges{k} = [1:4];
            
        case 'FullBodyRelationalReal'
            ranges{k} =[1:length_fullBodyRelationalReal];
        case 'FullBodyRelationalBool'
            ranges{k} =[1:length_fullBodyRelationalBool];
        case 'FullBodyAngularReal'
            ranges{k} =[1:length_fullBodyAngularReal];
        otherwise
            disp('Range for feature set not yet defined.')
            error('Range for feature set not yet defined.');
    end
end
