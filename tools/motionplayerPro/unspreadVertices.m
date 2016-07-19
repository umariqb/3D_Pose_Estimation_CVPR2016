function unspreadVertices(m)
    global SCENE;
    tmp                             = SCENE.mots{m}.vertices_tmp;
    SCENE.mots{m}.vertices_tmp      = SCENE.mots{m}.vertices;
    SCENE.mots{m}.vertices          = tmp;
    tmp                             = SCENE.mots{m}.boundingBox_tmp;
    SCENE.mots{m}.boundingBox_tmp   = SCENE.mots{m}.boundingBox;
    SCENE.mots{m}.boundingBox       = tmp;
    clear tmp;
end