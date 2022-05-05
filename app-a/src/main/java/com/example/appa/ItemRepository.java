package com.example.appa;

import org.springframework.data.jpa.repository.JpaRepository;


/**
 * Created by Jakub Krhovják on 5/5/22.
 */
public interface ItemRepository extends JpaRepository<Item, Long> {
}
