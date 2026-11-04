/**
 * ZagBench – BeRandomTreeNode (Java port of BeRandomTreeNode.class.st).
 *
 * Tree node used by BeStressGC to stress GC.
 * Children stored in a hand-grown array (no java.util.ArrayList).
 */
public class BeRandomTreeNode {

    private int              value;
    private BeRandomTreeNode parent;
    // Hand-grown dynamic array of children
    private BeRandomTreeNode[] children;
    private int                childCount;

    public BeRandomTreeNode() {
        this.children   = new BeRandomTreeNode[4];
        this.childCount = 0;
    }

    // ------------------------------------------------------------------
    // Accessors
    // ------------------------------------------------------------------

    public int  getValue()               { return value; }
    public void setValue(int v)          { this.value = v; }
    public BeRandomTreeNode getParent()  { return parent; }

    public int childCount()              { return childCount; }
    public BeRandomTreeNode childAt(int i) { return children[i]; }

    /** Append *node* as a child, resizing the backing array if necessary. */
    public void addChild(BeRandomTreeNode node) {
        node.parent = this;
        if (childCount == children.length) {
            BeRandomTreeNode[] newArr = new BeRandomTreeNode[children.length * 2];
            for (int i = 0; i < childCount; i++) newArr[i] = children[i];
            children = newArr;
        }
        children[childCount++] = node;
    }

    /** Remove the child at index *idx* (shifts later children left). */
    private void removeChildAt(int idx) {
        for (int i = idx; i < childCount - 1; i++) children[i] = children[i + 1];
        children[--childCount] = null;
    }

    // ------------------------------------------------------------------
    // liveNodes (direct children + self)
    // ------------------------------------------------------------------

    public int liveNodes() { return childCount + 1; }

    // ------------------------------------------------------------------
    // allNodes – iterative DFS to avoid stack overflow on large trees
    // ------------------------------------------------------------------

    public BeRandomTreeNode[] allNodes() {
        // Count first
        int total = subtreeSize();
        BeRandomTreeNode[] result = new BeRandomTreeNode[total];
        int idx = 0;
        // Iterative DFS with an explicit stack (hand-grown array)
        BeRandomTreeNode[] stack = new BeRandomTreeNode[total];
        int top = 0;
        stack[top++] = this;
        while (top > 0) {
            BeRandomTreeNode node = stack[--top];
            result[idx++] = node;
            // Push children in reverse order so leftmost is processed first
            for (int i = node.childCount - 1; i >= 0; i--)
                stack[top++] = node.children[i];
        }
        return result;
    }

    public int subtreeSize() {
        int total = 1;
        for (int i = 0; i < childCount; i++) total += children[i].subtreeSize();
        return total;
    }

    // ------------------------------------------------------------------
    // Subtree cutting
    // ------------------------------------------------------------------

    /** Remove the first half of direct children (Pharo cutHalfSubtrees). */
    public BeRandomTreeNode cutHalfSubtrees() {
        int half = childCount / 2;
        // Copy the first half to avoid concurrent-modification
        BeRandomTreeNode[] victims = new BeRandomTreeNode[half];
        for (int i = 0; i < half; i++) victims[i] = children[i];
        for (BeRandomTreeNode v : victims) removeChild(v);
        return this;
    }

    /** Remove a randomly chosen non-root node (Pharo cutRandomSubtree:). */
    public BeRandomTreeNode cutRandomSubtree(BeRandom random) {
        BeRandomTreeNode[] all = allNodes();
        if (all.length <= 1) return this;
        // Skip root (index 0), pick from the rest
        int idx  = random.nextInteger(all.length - 1); // 1-based in [1, n-1]
        BeRandomTreeNode pick = all[idx];               // picks index 1..(n-1)
        if (pick.parent != null) pick.parent.removeChild(pick);
        return this;
    }

    private void removeChild(BeRandomTreeNode node) {
        for (int i = 0; i < childCount; i++) {
            if (children[i] == node) { removeChildAt(i); return; }
        }
    }
}
