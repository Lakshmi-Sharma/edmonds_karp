# This is an implementation of Edmonds–Karp algorithm
# (Breadth first search specialization of Ford-Fulkerson Algorithm)
# for Maximum Flow Problem in Ruby

def maximum_flow(sources, sinks, graph_edges, directed: true, splitter: '#')

  parent_of = {}                                   # for individual paths
  infinity = Float::INFINITY                       # for infinite path flow
  maximum_flow = 0                                 # for storing total flow
  paths = Hash.new{|h,k| h[k] = {} }               # Hash of hashes to store path flows

  # Store paths in hash
  graph_edges.each do |edge|
    edge = edge.split(splitter)
    paths[edge[0]][edge[1]] = edge[2].to_i
    paths[edge[1]][edge[0]] = edge[2].to_i if !directed
  end

  # Store infinite flow for prime source to all sources and prime sink to all sinks
  sources.each{|source| paths['prime_source'][source] = infinity}
  sinks.each{|sink| paths[sink]['prime_sink'] = infinity}

  # If an augmenting path exists add its minimum flow to total flow and
  # recalculate path flows
  while bfs(parent_of, paths, 'prime_source', 'prime_sink')
    bfs_path = []
    to_node = 'prime_sink'
    min_flow = infinity

    # Get path (calculated backwards from prime sink) and min flow for that path
    loop do
      from_node = parent_of[to_node]
      flow = paths[from_node][to_node]
      if from_node != 'prime_source'
        if flow != infinity
          bfs_path << [from_node, to_node, flow]
          min_flow = [min_flow, flow].min
        end
        to_node = from_node
      else
        break
      end
    end

    # Add minimum flow of selected path to total flow
    maximum_flow += min_flow

    # Reduce flow from each edge
    bfs_path.each do |edge|
      paths[edge[0]][edge[1]] -= min_flow
      paths[edge[1]][edge[0]] = paths[edge[1]][edge[0]].to_i + (directed ? min_flow : -min_flow)
    end
  end

  return maximum_flow
end

# Breadth First Search to search for path from prime_source to prime_sink
def bfs(parent_of, paths, start_node, end_node)
  visited = []
  queue = []
  queue << start_node
  visited << start_node
  while queue.any?
    current_node = queue.shift
    paths[current_node].select{|node, flow| flow != 0}.each do |adjacent_node, val|
      next if visited.include?(adjacent_node)
      queue << adjacent_node
      visited << adjacent_node
      parent_of[adjacent_node] = current_node
    end
  end
  return visited.include?(end_node)
end

# Sample Input
# 1. Single Source, Single Sink with default settings ie. directed graph with graph-egdes splitter= '#'
sources = ['a']
sinks = ['d']
graph_edges = [ 'a#b#1000',
                'b#c#1',
                'b#d#1000',
                'a#c#1000',
                'c#d#1000'
                ]
p maximum_flow(sources, sinks, graph_edges)

# 2. Multiple Sources, Multiple Sinks with splitter = ','
sources = ['c2', 'c5', 'c7']
sinks = ['c4', 'c10']
graph_edges = [ 'c1,c2,6',
                'c2,c3,12',
                'c2,c4,3',
                'c3,c5,22',
                'c3,c6,23',
                'c4,c7,13',
                'c5,c8,16',
                'c6,c8,11',
                'c6,c9,9',
                'c7,c9,12',
                'c9,c10,15',
                'c8,c10,7']

# 2.1. Directed graph
p maximum_flow(sources, sinks, graph_edges, splitter: ',')

# 2.2. Undirected graph
p maximum_flow(sources, sinks, graph_edges, directed: false, splitter: ',')