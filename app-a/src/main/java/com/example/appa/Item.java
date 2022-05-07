package com.example.appa;

import javax.persistence.Entity;
import javax.persistence.Id;

import lombok.Data;
import lombok.experimental.Accessors;


/**
 * Created by Jakub Krhovják on 5/5/22.
 */
@Data
@Accessors(chain = true)
@Entity
public class Item {

    @Id
    private Long id;

    private String name;
}
