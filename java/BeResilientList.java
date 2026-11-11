/**
 * ZagBench – BeResilientList (Java port of BeResilientList.class.st).
 *
 * Singly-linked list node used to stress object/closure creation
 * in BeResilientBlocks.
 * No java.util.* imports.
 */
public class BeResilientList {

    private final BeResilientList next;

    private BeResilientList(BeResilientList next) {
        this.next = next;
    }

    /**
     * Build a chain of {@code size} nodes and return the head.
     * Equivalent to Pharo's {@code BeResilientList new: size}.
     */
    public static BeResilientList build(int size) {
        BeResilientList head = null;
        for (int i = 0; i < size; i++) {
            head = new BeResilientList(head);
        }
        return head;
    }

    /** Count nodes in the chain (O(n)). */
    public int size() {
        int count = 0;
        BeResilientList node = this;
        while (node != null) {
            count++;
            node = node.next;
        }
        return count;
    }
}
