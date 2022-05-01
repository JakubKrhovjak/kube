package com.example.appa;

import lombok.Data;

import javax.persistence.Entity;
import javax.persistence.Id;

@Entity
@Data
public class Item {

    @Id
    private Long id;

    private String name;

}
