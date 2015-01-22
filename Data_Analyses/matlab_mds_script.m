
labels = {'  1/6', '  2/9', '  5/21', '  4/16', '  6/24', '  2/6',...
            '  9/27', '  12/22', '  6/9', '  2/3', '  15/21',...
            '  5/7', '  3/4', '  7/8'};

subj = {'s_01010', 's_01003'};

tasks = {'sum','comp','nline','dots'};
ns = length(subj);
nt = length(tasks);
mat_list = cell(1, ns*nt);

for sub=1:length(subj)
    for task=1:length(tasks)
        ind = ((sub-1)*4)+task;
        mat_list{1,ind} = strcat(tasks{task}, '_', subj{sub});
    end
end
%Big_brain_mat = big_test
%Big_brain_mat = load('Corrected2_brain_mats.mat')
%Big_brain_mat = load('Corrected_Wholebrain_mats.mat')
Big_brain_mat = load('/Volumes/LaCie/fMRI/Fractions/Brain_mats_IPS.mat')
areas_names = fieldnames(Big_brain_mat); 
for i = 1:length(areas_names)
    Area_list = Big_brain_mat.(areas_names{i});
    for j = 1:size(Area_list, 1)
        mds_mat = Area_list(j,:,:);
        mds_mat = squeeze(mds_mat);
        [Y, e] = cmdscale(mds_mat);
        h = figure(j);
        clf;
        plot(Y(:,1),Y(:,2), 'k.')
        text(Y(:,1),Y(:,2),labels)
        %axis('off')
        axis(1.3*[min(Y(:,1)) max(Y(:,1)) min(Y(:,2)) max(Y(:,2))])
        xlabel('Dimension 1')
        ylabel('Dimension 2')
        dir = '/Volumes/LaCie/fMRI/Fractions/MDS/';
        first = areas_names{i};
        middle = '_';
        last = mat_list(1,j);
        ext = '.pdf';
        title_text = first;
        title_text = strcat(first, '_', mat_list(1,j));
        title_text = strrep(title_text, '_', ' ');
        title(title_text);
        fou = strcat(dir, first, middle, last, ext);
        %print(figure(j), '-dpdf', filename)
        print(h,'-dpdf', fou{:});
    end
end
