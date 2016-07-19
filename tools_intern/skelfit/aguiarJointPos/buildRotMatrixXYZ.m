function A = buildRotMatrixXYZ( alpha, beta, gamma )

A = buildRotMatrix([1 0 0], alpha) * buildRotMatrix([0 1 0], beta) * buildRotMatrix([0 0 1], gamma);