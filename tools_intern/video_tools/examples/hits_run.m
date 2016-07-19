index = index_build(F,[1 2 10 11 16 17]);
q=[ 9    10    14     6     5    15    11     9    10    14     6     5    13 15 11 ];
hits=retrieve_mismatch(index,q,7);
I=find(cell2mat({hits.file_id})<=178);
hits = hits(I);

L=cell2mat({hits.frame_length});
[L,I] = sort(L);
hits = hits(I);
