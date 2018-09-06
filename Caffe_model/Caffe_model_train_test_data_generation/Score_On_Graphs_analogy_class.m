function Scores3_all_labels=Score_On_Graphs_analogy_class(proposal_200_4kinds,groundtruth,Voxels_200, label_num, groupPixels_200)
X=proposal_200_4kinds;
GT=groundtruth(:,1);
GT_label=cell2mat(groundtruth(:,3));
num_proposal=length(X);
num_label=length(GT);
num_all_labels=label_num;  %label_numbers;
num_node=length(Voxels_200);


node_proposal=repmat(X,1,num_label);

GT_proposals=GT';
GT_proposals1=repmat(GT_proposals,num_proposal,1);

% intersect
Inter_GT_node_proposals=cellfun(@intersect , GT_proposals1,node_proposal, 'UniformOutput',false);
Inter_GT_node_proposals_volume=cellfun(@(x) Volume_sum(x,groupPixels_200), Inter_GT_node_proposals, 'UniformOutput',false);

% combine
node_proposals_volume=cellfun(@(x) Volume_sum(x,groupPixels_200), node_proposal, 'UniformOutput',false);

% analogy class scores
Scores1=cellfun(@score , Inter_GT_node_proposals_volume,node_proposals_volume, 'UniformOutput',false);
Scores2=cell2mat(Scores1);
Scores3=mat2cell(Scores2,ones(num_proposal,1),[num_label,0]);
Scores3(cellfun(@isempty,Scores3))=[];

% num_proposals* num_all_labels
Scores3_all_labels=cellfun(@(Scores3) transform(Scores3,GT_label,num_all_labels), Scores3,'UniformOutput',false);
Scores3_all_labels = Scores3_all_labels';
Scores3_all_labels = cell2mat(Scores3_all_labels);

end


function Vol_sum=Volume_sum(x,y)
    Vol_sum=sum(y(x));
end

function score1=score(x,y)
   score1=x/y;
end

function x1=transform(Scores3,GT_label,num_all_labels)
   label=unique(GT_label);    % labels this model contains
   x1=zeros(1,num_all_labels);   %labels in total
   for i=1:size(label,1)
       x1(label(i))=max(Scores3(GT_label==label(i)));
   end
end


