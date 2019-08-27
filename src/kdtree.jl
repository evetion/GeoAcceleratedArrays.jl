using NearestNeighbors

struct KDTreeIndex{I <: DataFreeTree} <: AbstractUniqueIndex
    dict::I
end

function KDTreeIndex(A::AbstractArray)
    dftree = DataFreeTree(KDTree, A)
    return KDTreeIndex(dftree)
end

Base.summary(::KDTreeIndex) = "KDTreeIndex"

# tree = injectdata(dftree, data)  # yields a KDTree
# knn(tree, data[:,1], 3)  # perform operations as usual
