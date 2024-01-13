import { classes } from 'common/react';
import { computeBoxClassName, computeBoxProps } from './Box';
import { Button } from './Button';

/*
const treeConfig = {
  // svgSrc: '/demo/demo_resources/tree.svg',
  imgDir: './demo_tree/',
  jsonSrc: '/demo/demo_tree.json',
  treeWidth: 800,
  treeHeight: 1000,


  closeTooltip: 'onmouseout',  // x-button || onmouseout
  openTooltip: 'onclick',  // onclick, onmouseover, or any svg attr
  showNodeNames: false,  // boolean
  showImages: true,
  futureTechFog: 'aesthetic',  // [ none || aesthetic || partial(not implemented) || complete(not implemented) ] sets to what degree unresearched tech should be shown
// TODO: add toggle buttons (or sliders) for the following :
  tooltipH: 200,
  tooltipW: 400,
  tooltipTextLineCount: 12,  // approx number of lines of description text in the tooltip
  nodeSize: 70,  // [px]
  transitionTime: 2000    // ms used for transitions

};
*/
export const TechGraph = (props) => {
  const { className, treeWidth, treeHeight, ...rest} = props
  // initial draw of the tree
  console.log('techtree module:\n');
  let width = treeWidth;
  let height = treeHeight;
  let txtSize = 16;
  let leftMargin = 250;  // TODO: figure this out dynamically

  return (
    <div className="TechGraph__Container">
      <svg id="tech-graph"
        height={treeHeight}
        width={treeWidth}>
        <g style={{"transform":"translate(40,0)"}} id="big-g">
          <circle cx={50} cy={50} r={20} fill="red" />
        </g>
      </svg>
    </div>
  );
};

const GraphNode = (props) => {
  const { className, nodeData, nodeX, nodeY } = props
  return (
    <g
      className={classes([
        'Node',
        className,
        computeBoxClassName(rest),
      ])}
      style={{"transform":"translate(" + nodeX + "," + nodeY + ")"}}>

    </g>
  );
}

const GraphEdge = (props) => {
  const { edge_src, edge_target, diagonal, visible } = props
  return (
    <path style={{
      "src":edge_src,
      "tgt":edge_target,
      "d": diagonal,
      "visibility": visible ? "visible" : "hidden"}} />
  );
}

// takes in an adjacencyTable and returns a 2D array of nodes in each of their respective graphs levels top down
const calculateGraphLevels = (props) => {
  const { adjacencyTable, startingNode } = props
  // The most important variable, 2D graph tracking which nodes are on each level
  const graphLevels = []
  // array of every node we have processed, since nodes can have multiple parents we need to make sure we're
  // not processing a node twice as we move top to bottom
  const visitedNodes = []
  // used to map a child node (key) to it's parent node (value) since we're only working with an adjacenyTable here
  const nodeParents = {}

  // which level we're current at, level 0 is the trunk level (should only have 1) and the max index will be the furthest
  // level with the leaf node with highest path length from trunk
  currentLevel = 0
  // The node we're currently processing
  currentNode = Object.keys(adjacencyTable)[startingNode]

  while (currentLevel >= 0) {
    if (graphLevels.length < currentLevel) {
      graphLevels.push([]) // if we're at a new level, push a new array to our 2D array
    }
    if (!graphLevels[currentNode].includes(currentNode)) {
      // it looks like the node we're on isn't already tracked on this level, add it to the array
      graphLevels[currentNode].push(currentNode)
    }
    // now we're going to loop through the children of currentNode
    for (const childNode in adjacencyTable[currentNode]) {
      if (visitedNodes.includes(childNode)) {
        continue // if we've already processed the child, skip it
      }
      // this child hasn't been processed, lets move down a level to it and start processing it
      nodeParents[childNode] = currentNode // we need to keep track of the parent of this child node so we can move back up to it later
      currentNode = childNode // current node becomes the child
      currentLevel++ // movin' down the line babyyy
      continue
    }
    // no more children to process, let's move back up the graph
    currentLevel--
    visitedNodes.push(currentNode)
    currentNode = nodeParents[currentNode] // grabbing the parent of our current node
  }

  return graphLevels
}

// takes in a 2D array of the graph level and returns the width of the largest level
const calculateGraphWidth = (props) => {
  const { graphLevels } = props
  maxLevelWidth = 0
  for (const level in graphLevels) {
    maxLevelWidth = Math.max(maxLevelWidth, level.length)
  }
  return maxLevelWidth
}

const drawTree = (props) => {
  const { nodeData, adjacencyTable, children, ...rest} = props
  // initial draw of the tree
  console.log('techtree module:\n');
  let width = treeWidth
  let height = treeHeight
  let txtSize = 16;
  let leftMargin = 250;  // TODO: figure this out dynamically

  let nodes = [];
  let edges = [];

  let big_graphic = document.querySelector('#big-g')

  let nodeCoords = {}
  let edgeData = {}
  const graphLevels = calculateGraphLevels(adjacencyTable = adjacencyTable, startingNode = 0)


  node_spacing = 20

  // this works on the assumption that the first node in the table is the trunk node
  nodeX = calculateGraphWidth(graphLevels = graphLevels) / 2 // measured in "units", not any particular measurement yet
  nodeY = 1
  for (const row in graphLevels) {
    for (const level_node in graphLevels[row]) {

      adjacencyTable[level_node].length
    }
    nodeY++
  }

  return (
    <>
      {adjacencyGraph.map((node) => (
        <g className="node">

        </g>
      ))}
    </>
  );
  /*
  let tree = d3.layout.tree()
      .size([height, width - leftMargin]);

  let diagonal = d3.svg.diagonal()
      .projection(function(d) { return [d.y, d.x]; });

  d3.json(treeConfig.jsonSrc, function(error, json) {
    let nodes = tree.nodes(json),
        links = tree.links(nodes);

        console.log(links);

    let link = techtree.treeSVG.selectAll("path.link")
          .data(links)
      .enter().append("path")
          .attr("src",function(d) { return d.source.name; })
          .attr("tgt",function(d) { return d.target.name; })
          .attr("class", "link-dflt")
          .attr("d", diagonal);

    var node = techtree.treeSVG.selectAll("g.node")
        .data(nodes)
      .enter().append("g")
        .attr("class", "node")
        .attr("transform", function(d) { return "translate(" + d.y + "," + d.x + ")"; })

    techtree._drawNodeBoxes(node);


    node.append("text")
        .attr("dx", 10) // function(d) { return d.children ? -12 : 12; })
        .attr("dy", 3)
        .attr("text-anchor", "start") // function(d) { return d.children ? "end" : "start"; })
        .attr('font-size',txtSize)
        .text(treeConfig.showNodeNames ? (function(d) { return d.name; }) : undefined);
  });

  d3.select(self.frameElement).style("height", height + "px");

  // set up classes for transitions
  techtree.tpl_link_available = d3.select('body').append('div').attr('class', 'link-available').style('display', 'none');
  techtree.tpl_link_complete = d3.select('body').append('div').attr('class', 'link-complete').style('display', 'none');
}



// the main techtree module
const techtree = {


  // PRIVATE METHODS/ATTR:
  _dismissedTooltip: undefined,


  _drawNodeBoxes: function(node){
      var NODE_SIZE = treeConfig.nodeSize;

      if (treeConfig.showImages){
        // add the pattern for each node picture
        node.append('svg:pattern')
        .attr('id', function(d){return d.name+'_img'})
        .attr('patternUnits', 'userSpaceOnUse')
        .attr('width', NODE_SIZE)
        .attr('height', NODE_SIZE)
        .attr('x',NODE_SIZE/2)
        .attr('y',NODE_SIZE/2)
        .append('svg:image')
          .attr('xlink:href', function(d){return treeConfig.imgDir+d.name+'.png'})
          .attr('x', 0)
          .attr('y', 0)
          .attr('width', NODE_SIZE)
          .attr('height', NODE_SIZE);

         // add the node rect using image patterns
         node.append("rect")
               .attr("id",function(d) { return d.name+"_circle"; })
               .attr("rx", NODE_SIZE/4)
               .attr("ry", NODE_SIZE/4)
               .attr("y", -NODE_SIZE/2)
               .attr("x", -NODE_SIZE/2)
               .attr("width", NODE_SIZE)
               .attr("height", NODE_SIZE)
               .style("fill", function(d) {return "url(#"+d.name+'_img)' })
               .classed('node-img');
      } else {
         node.append("rect")
               .attr("id",function(d) { return d.name+"_circle"; })
               .attr("rx", NODE_SIZE/4)
               .attr("ry", NODE_SIZE/4)
               .attr("y", -NODE_SIZE/2)
               .attr("x", -NODE_SIZE/2)
               .attr("width", NODE_SIZE)
               .attr("height", NODE_SIZE)
      }

      if (treeConfig.futureTechFog == 'aesthetic'){
         node.append("rect")
               .attr("id",function(d) { return d.name+"_fog"; })
               .attr("rx", NODE_SIZE/4)
               .attr("ry", NODE_SIZE/4)
               .attr("y", -NODE_SIZE/2)
               .attr("x", -NODE_SIZE/2)
               .attr("width", NODE_SIZE)
               .attr("height", NODE_SIZE)
        node.classed("fogged", function(d){ return !techtree._isEnabled(d.depth,d.name)});
      }

      node.classed("unlocked",  function(d){ return techtree._isEnabled(  d.depth, d.name)});
      node.classed("completed", function(d){ return techtree._isCompleted(d.depth, d.name)});

  },
*/
};

