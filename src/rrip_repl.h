#ifndef RRIP_REPL_H_
#define RRIP_REPL_H_

#include "repl_policies.h"


struct TreeNode {
    uint64_t plru_bit;
    bool is_left;
    TreeNode *parent; 
    TreeNode *left;   // Pointer to the left subtree.
    TreeNode *right;  // Pointer to the right subtree.
};

struct TreeNode** create_tree(uint64_t _leaves)
{    
    uint64_t count = 0;
    uint64_t node_position = 0;
    uint64_t node_size = _leaves * 2 - 1; 
    
    TreeNode** node_array = gm_calloc<TreeNode*>(node_size);
    
    TreeNode* root = new TreeNode;
    root->plru_bit = 0;
    root->left = NULL;
    root->right = NULL;
    root->parent = NULL;
    root->is_left = true;
    
    TreeNode* current =root;
    node_array[count] = root;
    count++;

    while(count < node_size){
        
        TreeNode* new_node = new TreeNode;
        new_node->plru_bit = 0;
        new_node->left = NULL;
        new_node->right = NULL;
        node_array[count] = new_node;
        
        if(current->left == NULL){
            current->left = new_node;
            new_node->parent = current;
            new_node->is_left = true;
            count++;
            continue;
        }
        if(current->right == NULL){
            current->right = new_node;
            new_node->parent = current;
            new_node->is_left = false;            
            node_position++;
            current = node_array[node_position];            
            count++;
            continue;            
        }       
    }   
    return node_array;   
}

int *get_bits(int n){

    int value = n;
    int count = 0;
    while (value > 0) {
        count++;
        value = value >> 1;
    }
      int *bits = (int*)malloc(sizeof(int) * count);

      int k;
      for(k=0; k<count; k++){
        int mask =  1 << k;
        int masked_n = n & mask;
        int thebit = masked_n >> k;
        bits[k] = thebit;
      }
      return bits;

}


int set_index(TreeNode* p, int x){

    int *bit =get_bits(x);
    int i = 0;
    TreeNode* tmp = p;
    while(tmp -> parent != NULL){
        if(tmp->is_left == false){
            tmp -> parent ->plru_bit = (uint64_t)bit[i];      
        }
        else{
            if(bit[i] == 1){
                tmp -> parent ->plru_bit = 0; 
            }
            if(bit[i] == 0){
                tmp -> parent ->plru_bit = 1; 
            }                       
        }
        tmp = tmp -> parent;
        i++;
    }

    return x;
}

int find_index(TreeNode* p){

    int x = 0;
    int i = 0;
    TreeNode* tmp = p;
    while(tmp -> parent != NULL){
        if(tmp -> is_left == false){
            if(tmp->parent->plru_bit == 1){
                x = x + pow(2,i);         
            }            
        }
        else{
            if(tmp->parent->plru_bit == 0){
                x = x + pow(2,i);              
            }           
        }
        tmp = tmp -> parent;
        i++;
    }

    return x;
}


class MDPPPolicy : public ReplPolicy{
    protected:
        TreeNode** root_array;
        TreeNode** leaf_array;
        uint64_t numLines;
        uint64_t set;
        uint64_t leaf_size;
        uint64_t node_size;
        int place_pos;
        int* position_array;
        
    public:
        explicit MDPPPolicy(uint32_t _numLines, uint32_t _set)  {

            set = _set;
            numLines =_numLines;
            root_array = gm_calloc<TreeNode*>(set);
            leaf_size = numLines / set;            
            leaf_array = gm_calloc<TreeNode*>(numLines);
            node_size = leaf_size * 2 - 1;
            place_pos = (int)((leaf_size/4)*3);
            uint32_t counter = 0;
            for(uint64_t i = 0;i < set;i++){
                TreeNode** temp = create_tree(leaf_size);
                root_array[i] = temp[0];
                for(uint64_t i = 0;i < node_size;i++){
                    if(temp[i]->left == NULL && temp[i]->right == NULL){
                        leaf_array[counter] = temp[i];
                        counter++;                        
                    }                    
                }
            }

            position_array = gm_calloc<int>(leaf_size);
            int p_div = leaf_size / 2;
            int p_counter = 0;
            int p_pos = 0;
            
            while(p_div != 1){
                position_array[p_counter] = p_pos;
                p_counter++;
                p_pos++;
                if(p_div == p_pos){
                    p_pos = 0;
                    p_div = p_div / 2;
                }                
            }  
          
            
        }
        
        ~MDPPPolicy() {
            gm_free(root_array);
            gm_free(leaf_array);
            gm_free(position_array);
        }
               
        
        void update(uint32_t id, const MemReq* req){

            TreeNode* current = leaf_array[id];
            if(current-> plru_bit == 2){
                set_index(current, place_pos);  
                current-> plru_bit = 0;                 
            }
            else{
                int current_index = find_index(current);
                int new_index = position_array[current_index];
                set_index(current,new_index);
            }

        }
        
        void replaced(uint32_t id) {

            TreeNode* current = leaf_array[id];
            current-> plru_bit = 2;

        }
        
        template <typename C> inline uint32_t rank(const MemReq* req, C cands) {

            uint32_t bestCand = -1;
            auto ci = cands.begin();
            uint32_t current_set = ((*ci)/ leaf_size);
            TreeNode* current_node = root_array[current_set];
            while(current_node->left != NULL){
                if(current_node->plru_bit == 1){
                    current_node = current_node -> right;
                }
                else{
                    current_node = current_node -> left;
                }                
            }
            for(uint32_t i=0;i<leaf_size*set;i++){
                if(leaf_array[i] == current_node){
                    bestCand = i;
                }                
            }

            return bestCand;
        }
        
        DECL_RANK_BINDINGS;
        
    
};







class PLRUReplPolicy : public ReplPolicy{
    protected:
        TreeNode** root_array;
        TreeNode** leaf_array;
        uint64_t numLines;
        uint64_t set;
        uint64_t leaf_size;
        uint64_t node_size;
    
    public:
        explicit PLRUReplPolicy(uint32_t _numLines, uint32_t _set)  {
            set = _set;
            numLines =_numLines;
            root_array = gm_calloc<TreeNode*>(set);
            leaf_size = numLines / set;            
            leaf_array = gm_calloc<TreeNode*>(numLines);
            node_size = leaf_size * 2 - 1;
            uint32_t counter = 0;
            for(uint64_t i = 0;i < set;i++){
                TreeNode** temp = create_tree(leaf_size);
                root_array[i] = temp[0];
                for(uint64_t i = 0;i < node_size;i++){
                    if(temp[i]->left == NULL && temp[i]->right == NULL){
                        leaf_array[counter] = temp[i];
                        counter++;                        
                    }                    
                }
            }
        }

        ~PLRUReplPolicy() {
            gm_free(root_array);
        }
        
        void update(uint32_t id, const MemReq* req){
            TreeNode* current = leaf_array[id];
            while(current->parent != NULL){
                if(current->is_left == true){
                    current->parent->plru_bit = 1;                    
                }
                else{
                    current->parent->plru_bit = 0;
                }
                current = current -> parent;
            }            
        }
        

        
        void replaced(uint32_t id) {
          
        }
        
        
        
        
        template <typename C> inline uint32_t rank(const MemReq* req, C cands) {
            uint32_t bestCand = -1;
            auto ci = cands.begin();
            uint32_t current_set = ((*ci)/ leaf_size);
            TreeNode* current_node = root_array[current_set];
            while(current_node->left != NULL){
                if(current_node->plru_bit == 1){
                    current_node = current_node -> right;
                }
                else{
                    current_node = current_node -> left;
                }                
            }
            for(uint32_t i=0;i<leaf_size*set;i++){
                if(leaf_array[i] == current_node){
                    bestCand = i;
                }                
            }
            return bestCand;
        }
        
        DECL_RANK_BINDINGS;
           
    
};



class SRRIPReplPolicy : public ReplPolicy {
    protected:
        // add class member variables here
        uint64_t* array;
        uint64_t max_rrpv;
        uint64_t numLines;        
        
    public:
        explicit SRRIPReplPolicy(uint32_t _numLines, uint32_t _max_rrpv) : max_rrpv(_max_rrpv), numLines(_numLines) {
            array = gm_calloc<uint64_t>(numLines);
            for(uint64_t i = 0;i < numLines-1;i++){
                array[i] = max_rrpv;  
            }
        }

        ~SRRIPReplPolicy() {
            gm_free(array);
        }
        
        void update(uint32_t id, const MemReq* req) {
            if(array[id] > (uint32_t)max_rrpv){
                array[id] = max_rrpv - 1;               
            }
            else{
                array[id] = 0;                
            }           
        }
        
        void replaced(uint32_t id) {
            array[id] = max_rrpv + 1;
        }
        
        template <typename C> inline uint32_t rank(const MemReq* req, C cands) {
            uint32_t bestCand = -1;
            while(true){
                for (auto ci = cands.begin(); ci != cands.end(); ci.inc()) {
                    uint64_t s = score(*ci);
                    bestCand = *ci;
                    if(s == max_rrpv){ 
                        return bestCand;                        
                    }                        
                }
                for (auto ci = cands.begin(); ci != cands.end(); ci.inc()) {
                    increase(*ci);
                }
            }        

        }
        
        DECL_RANK_BINDINGS;
        
        private:
            inline uint64_t score(uint32_t id) { //higher is least evictable
                return array[id];
            }
            
            inline void increase(uint32_t id) { //higher is least evictable
          
                array[id]++;

            }
            
        
        
        // add member methods here, refer to repl_policies.h

        //DECL_RANK_BINDINGS;
};
#endif // RRIP_REPL_H_
